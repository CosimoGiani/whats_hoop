class UserModel {

  String id;
  String email;
  String firstName;
  String lastName;
  int type;
  String? teamID;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.type,
    this.teamID,
  });

}