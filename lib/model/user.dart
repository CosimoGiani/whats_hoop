class UserModel {

  String? id;
  String? email;
  String? firstName;
  String? lastName;
  int? type;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.type
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      type: map['type']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'type': type
    };
  }

}