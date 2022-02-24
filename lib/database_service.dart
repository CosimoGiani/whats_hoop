import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/activity.dart';
import 'models/team.dart';

class DatabaseService {

  final firestoreInstance = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance.currentUser;

  Future removeTeam(String teamID) async {
    await firestoreInstance.collection("teams").doc(teamID).delete();
  }

  Future removeActivity(String activityID) async {
    await firestoreInstance.collection("activities").doc(activityID).delete();
  }

  Future<List<Team>> getTeamsFromTrainerID(String trainerID) async {
    List<Team> teamsTrainer = [];
    var teamsData = await firestoreInstance.collection("teams").where("trainerID", isEqualTo: trainerID).get();
    for (var value in teamsData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String name = data["name"];
      int numPartecipants = int.parse(data["numPartecipants"]);
      String trainerID = data["trainerID"];
      teamsTrainer.add(Team(id: id, name: name, numPartecipants: numPartecipants, trainerID: trainerID));
    }
    return teamsTrainer;
  }

  Future<Team> addNewTeam(TextEditingController nameController) async {
    String name = nameController.text;
    String trainerID = _authUser!.uid.toString();
    DocumentReference ref = await firestoreInstance.collection("teams").add({
      "name": nameController.text,
      "numPartecipants": "0",
      "trainerID": trainerID,
    });
    firestoreInstance.collection("teams").doc("${ref.id}").update({"id":"${ref.id}"});
    Team team = Team(id: ref.id, name: name, numPartecipants: 0, trainerID: trainerID);
    return team;
  }

  Future<List<Activity>> getActivitiesByTeamID(String teamID) async {
    List<Activity> activities = [];
    var activitiesData = await firestoreInstance.collection("activities").where("teamID", isEqualTo: teamID).get();
    for(var value in activitiesData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String type = data["type"];
      String date = data["date"];
      String time = data["time"];
      String place = data["place"];
      String notes = data["notes"];
      String teamID = data["teamID"];
      activities.add(Activity(id: id, type: type, time: time, date: date, place: place, notes: notes, teamID: teamID));
    }
    return activities;
  }

  Future<Activity> addNewActivity(String teamID, String value, String date, String time, TextEditingController placeController, TextEditingController notesController) async {
    DocumentReference ref = await firestoreInstance.collection("activities").add({
      "type": value,
      "date": date,
      "time": time,
      "place": placeController.text,
      "notes": notesController.text,
      "teamID": teamID,
    });
    var document = firestoreInstance.collection("activities").doc("${ref.id}");
    document.update({"id":"${ref.id}"});
    Activity activity = Activity(id: ref.id, type: value, date: date, time: time, place: placeController.text, notes: notesController.text, teamID: teamID);
    return activity;
  }

}