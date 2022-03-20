import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'package:whatshoop/models/activity.dart';
import 'package:whatshoop/models/user.dart';
import 'package:whatshoop/models/fine.dart';
import 'package:whatshoop/models/team.dart';

class DatabaseService {

  final firestoreInstance = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance.currentUser;

  Future removeTeam(String teamID) async {
    await firestoreInstance.collection("teams").doc(teamID).delete();
  }

  Future removeActivity(String activityID) async {
    Activity activity = await getActivityFromActivityID(activityID);
    List<Survey> surveys = await getSurveysByTeamID(activity.teamID);
    for (var survey in surveys) {
      if (survey.title == "${activity.type} ${activity.date}") {
        await removeSurvey(survey.id);
      }
    }
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

  Future<Activity> getActivityFromActivityID(String activityID) async {
    var data = (await firestoreInstance.collection("activities").doc(activityID).get()).data();
    return Activity(id: activityID, type: data!["type"], date: data["date"], time: data["time"], place: data["place"], notes: data["notes"], teamID: data["teamID"]);
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

  Future<List<UserModel>> getPlayersFromTeamID(String teamID) async {
    List<UserModel> players = [];
    var playersData = await firestoreInstance.collection("users").where("teamID", isEqualTo: teamID).get();
    for (var value in playersData.docs) {
      Map<String, dynamic> data = value.data();
      String id = data["id"];
      String email = data["email"];
      String firstName = data["firstName"];
      String lastName = data["lastName"];
      int type = data["type"];
      String teamID = data["teamID"];
      players.add(UserModel(id: id, email: email, firstName: firstName, lastName: lastName, type: type, teamID: teamID));
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
    String question = "";
    if (value == "Allenamento") {
      question = "Parteciperai all'allenamento";
    } else {
      question = "Parteciperai alla partita";
    }
    List<String> options = ["Si", "No", "Forse - non lo so ancora"];
    await addNewSurvey(teamID, "$value $date", "$question del giorno $date?", options);
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

  Future<int> getNumVotesFromSurvey(Survey survey) async {
    var data = (await firestoreInstance.collection("surveys").doc(survey.id).get()).data();
    return data!["numVotes"];
  }

  Future userVote(Survey survey, String userID, String optionVoted, bool valueOptionVoted) async {
    var document = await firestoreInstance.collection("surveys").doc(survey.id);
    var data = (await firestoreInstance.collection("surveys").doc(survey.id).get()).data();
    for (var option in survey.options) {
      // se clicca su una risposta e non è selezionata di già
      if (option == optionVoted && valueOptionVoted) {
        List<dynamic> votes = data![option];
        // se è già selezionata un'altra risposta viene rimosso il voto e "resetatto" nel db
        for (var opt in survey.options) {
          List<dynamic> test = data[opt];
          if (test.contains(userID)) {
            test.removeWhere((element) => element == userID);
            int newNum = await getNumVotesFromSurvey(survey);
            await document.update({opt: test, "numVotes": newNum - 1});
          }
        }
        // aggiunge il voto della risposta selezionata
        votes.add(userID);
        int newNumVotes = await getNumVotesFromSurvey(survey);
        await document.update({optionVoted: votes, "numVotes": newNumVotes + 1});
      }
      // se clicca su una risposta che è già selezionata la deseleziona
      if (option == optionVoted && !valueOptionVoted) {
        List<dynamic> votes = data![option];
        votes.removeWhere((element) => element == userID);
        int newNumVotes = await getNumVotesFromSurvey(survey);
        document.update({optionVoted: votes, "numVotes": newNumVotes - 1});
      }
    }
  }

  Future<bool> getCheckboxValue(Survey survey, String userID, String element) async {
    var data = (await firestoreInstance.collection("surveys").doc(survey.id).get()).data();
    List<dynamic> votes = data![element];
    if (votes.contains(userID)) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel> getUserFromID(String id) async {
    var data = (await firestoreInstance.collection("users").doc(id).get()).data();
    return UserModel(id: data!["id"], email: data["email"], firstName: data["firstName"], lastName: data["lastName"], type: data["type"], teamID: data["teamID"]);
  }

  Future<UserModel> getUserFromEmail(String email) async {
    var user = (await firestoreInstance.collection("users").where("email", isEqualTo: email).get()).docs;
    var data = user[0].data();
    return UserModel(id: data["id"], email: data["email"], firstName: data["firstName"], lastName: data["lastName"], type: data["type"], teamID: data["teamID"]);
  }

  Future<Team> getTeamFromID(String id) async {
    var data = (await firestoreInstance.collection("teams").doc(id).get()).data();
    return Team(id: data!["id"], name: data["name"], numPartecipants: int.parse(data["numPartecipants"]), trainerID: data["trainerID"]);
  }

  Future<Team> getTeamInviteFromUserID(String userID) async {
    var docs = (await firestoreInstance.collection("team_invitations").where("userID", isEqualTo: userID).get()).docs;
    var data = docs[0].data();
    Team team = await getTeamFromID(data["teamID"]);
    return team;
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

  Future<bool> checkInvite(String userID) async {
    var invite = (await firestoreInstance.collection("team_invitations").where("userID", isEqualTo: userID).get()).docs;
    if (invite.isNotEmpty) {
      return true;
    } else {
      return false;
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

  Future acceptInvite(String userID, String teamID) async {
    await firestoreInstance.collection("team_invitations").where("userID", isEqualTo: userID).get()
    .then((value) {
      for (var element in value.docs) {
        firestoreInstance.collection("team_invitations").doc(element.id).delete();
      }
    });
    await firestoreInstance.collection("users").doc(userID).update({"teamID": teamID});
    Team teamToUpdate = await getTeamFromID(teamID);
    await firestoreInstance.collection("teams").doc(teamID).update({"numPartecipants": teamToUpdate.numPartecipants + 1});
  }

  Future rejectInvite(String userID, String teamID) async {
    await firestoreInstance.collection("team_invitations").where("userID", isEqualTo: userID).get()
    .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (teamID == data["teamID"]) {
          firestoreInstance.collection("team_invitations").doc(element.id).delete();
        }
      }
    });
  }

  Future removeAthleteFromTeam(String userID, String teamID) async {
    await firestoreInstance.collection("users").doc(userID).update({"teamID": ""});
    Team teamToUpdate = await getTeamFromID(teamID);
    await firestoreInstance.collection("teams").doc(teamID).update({"numPartecipants": teamToUpdate.numPartecipants - 1});
  }

  Future updateModifiedActivity(Activity activity, String value, String date, String time, String place, String notes) async {
    await firestoreInstance.collection("activities").doc(activity.id).update({
      "type": value,
      "date": date,
      "time": time,
      "place": place,
      "notes": notes,
    });
  }

}