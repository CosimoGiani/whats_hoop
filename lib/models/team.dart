//import 'user.dart';

class Team {

  String name;
  int numPartecipants;
  //List<User> users;
  //User trainer;
  String trainerID;

  Team({
    required this.name,
    required this.numPartecipants,
    //this.users = const [],
    //required this.trainer,
    this.trainerID = "",
  });

}