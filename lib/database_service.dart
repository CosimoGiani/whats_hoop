import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/team.dart';

class DatabaseService {

  final firestoreInstance = FirebaseFirestore.instance;

  Future removeTeam(Team? team, String userID) async {
    if (userID == team!.trainerID) {
      await firestoreInstance.collection("teams").where("name", isEqualTo: team.name).get()
          .then((teamToDelete) {
        teamToDelete.docs[0].reference.delete();
      });
    }
  }

  Future<List<Team>> getTeamsFromTrainerID(String trainerID) async {
    List<Team> teamsTrainer = [];
    var teamsData = await firestoreInstance.collection("teams").where("trainerID", isEqualTo: trainerID).get();
    for (var value in teamsData.docs) {
      Map<String, dynamic> data = value.data();
      String name = data["name"];
      int numPartecipants = int.parse(data["numPartecipants"]);
      String trainerID = data["trainerID"];
      teamsTrainer.add(Team(name: name, numPartecipants: numPartecipants, trainerID: trainerID));
    }
    return teamsTrainer;
  }

}