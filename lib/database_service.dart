import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'models/activity.dart';
import 'package:whatshoop/models/user.dart' as Player;
import 'models/fine.dart';
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

  Future removeSurvey(String surveyID) async {
    await firestoreInstance.collection("surveys").doc(surveyID).delete();
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

  Future<List<Player.UserModel>> getPlayersFromTeamID(String teamID) async {
    List<Player.UserModel> players = [];
    var playersData = await firestoreInstance.collection("users").where("teamID", isEqualTo: teamID).get();
    for (var value in playersData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String email = data["email"];
      String firstName = data["firstName"];
      String lastName = data["lastName"];
      int type = data["type"];
      String teamID = data["teamID"];
      players.add(Player.UserModel(id: id, email: email, firstName: firstName, lastName: lastName, type: type, teamID: teamID));
    }
    return players;
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

  Future<List<Survey>> getSurveysByTeamID(String teamID) async {
    List<Survey> surveys = [];
    var surveysData = await firestoreInstance.collection("surveys").where("teamID", isEqualTo: teamID).get();
    for (var value in surveysData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String teamID = data["teamID"];
      String title = data["title"];
      String question = data["question"];
      List<dynamic> options = data["options"];
      int numVotes = data["numVotes"];
      surveys.add(Survey(id: id, teamID: teamID, title: title, question: question, options: options.cast<String>(), numVotes: numVotes));
    }
    return surveys;
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

  Future<Survey> addNewSurvey(String teamID, String title, String question, List<String> options) async {
    DocumentReference ref = await firestoreInstance.collection("surveys").add({
      "teamID": teamID,
      "title": title,
      "question": question,
      "options": options,
      "numVotes": 0,
    });
    var document = firestoreInstance.collection("surveys").doc("${ref.id}");
    document.update({"id":"${ref.id}"});
    for (int i = 0; i < options.length; i++) {
      String name = options[i];
      List<String> list = [];
      document.update({name: list});
    }
    return Survey(id: ref.id, teamID: teamID, title: title, question: question, options: options, numVotes: 0);
  }
  
  Future<List<int>> getSurveyVotes(Survey survey) async {
    List<int> votes = [];
    var data = (await firestoreInstance.collection("surveys").doc(survey.id).get()).data();
    for (var value in survey.options) {
      List<dynamic> vote = data![value];
      votes.add(vote.length);
    }
    return votes;
  }

  Future<Player.UserModel> getUserFromID(String id) async {
    var data = (await firestoreInstance.collection("users").doc(id).get()).data();
    return Player.UserModel(id: data!["id"], email: data["email"], firstName: data["firstName"], lastName: data["lastName"], type: data["type"], teamID: data["teamID"]);
  }

  Future<Player.UserModel> getUserFromEmail(String email) async {
    var user = (await firestoreInstance.collection("users").where("email", isEqualTo: email).get()).docs;
    var data = user[0].data();
    return Player.UserModel(id: data["id"], email: data["email"], firstName: data["firstName"], lastName: data["lastName"], type: data["type"], teamID: data["teamID"]);
  }

  Future sendInvite(String teamID, String userID) async {
    String? userTeamID = (await getUserFromID(userID)).teamID;
    if (userTeamID != teamID) {
      await firestoreInstance.collection("team_invitations").add({
        "teamID": teamID,
        "userID": userID,
      });
    }
  }

  Future<Fine> finePlayer(String reason, int euro, int cents, String date, String playerID) async {
    DocumentReference ref = await firestoreInstance.collection("fines").add({
      "reason": reason,
      "euro": euro,
      "cents": cents,
      "date": date,
      "playerID": playerID,
    });
    var document = firestoreInstance.collection("fines").doc(ref.id);
    document.update({"id": ref.id});
    Fine fine = Fine(id: ref.id, reason: reason, euro: euro, cents: cents, date: date, playerID: playerID);
    return fine;
  }

  Future<List<Fine>> getFinesFromPlayerID(String playerID) async {
    List<Fine> fines = [];
    var finesData = await firestoreInstance.collection("fines").where("playerID", isEqualTo: playerID).get();
    for(var value in finesData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String reason = data["reason"];
      int euro = data["euro"];
      int cents = data["cents"];
      String date = data["date"];
      String playerID = data["playerID"];
      fines.add(Fine(id: id, reason: reason, euro: euro, cents: cents, date: date, playerID: playerID));
    }
    return fines;
  }

  Future clearPlayerFines(String playerID) async {
    await firestoreInstance.collection("fines").where("playerID", isEqualTo: playerID).get()
    .then((value) {
      for (var element in value.docs) {
        firestoreInstance.collection("fines").doc(element.id).delete();
      }
    });
  }

  Future removeFine(String fineID) async {
    await firestoreInstance.collection("fines").doc(fineID).delete();
  }

}