import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/models/fine.dart';
import 'package:whatshoop/models/user.dart';
import 'package:whatshoop/screens/fines_athlete_page.dart';
import 'package:whatshoop/screens/login.dart';
import 'package:whatshoop/screens/trainer_home.dart';

class Profile extends StatefulWidget {

  String mode;
  Profile(this.mode);

  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {

  final DatabaseService service = new DatabaseService();
  final authUser = FirebaseAuth.instance.currentUser;
  late UserModel currentUser;
  final auth = FirebaseAuth.instance;
  List<Fine> fines = [];

  Future _loadData() async {
    currentUser = await service.getUserFromID(authUser!.uid);
    fines = await service.getFinesFromPlayerID(currentUser.id);
  }

  Widget getTrainerView() {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(""),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(""),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 5),
                  child: Icon(Icons.account_circle_rounded, size: 70, color: Colors.red),
                ),
              ),
              Center(
                child: Text(
                  currentUser.firstName,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrangeAccent.withOpacity(0.7),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset: Offset(3, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text("I tuoi dati personali", style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 15, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Nome", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.firstName, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Cognome", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.lastName, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("E-mail", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.email, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
                child: RaisedButton(
                  color: Colors.deepOrangeAccent,
                  child: Text("Torna alle tue squadre", style: TextStyle(color: Colors.white, fontSize: 22)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TrainerHome()));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onSurface: Colors.deepOrangeAccent,
                    elevation: 7,
                    padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Esci", style: TextStyle(color: Colors.white, fontSize: 22)),
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getAthleteView() {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(""),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(""),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 5),
                  child: Icon(Icons.account_circle_rounded, size: 70, color: Colors.red),
                ),
              ),
              Center(
                child: Text(
                  currentUser.firstName,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrangeAccent.withOpacity(0.7),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset: Offset(3, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text("I tuoi dati personali", style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 15, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Nome", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.firstName, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Cognome", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.lastName, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: Offset(3, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("E-mail", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(currentUser.email, style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 0, 35, 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurRadius: 7,
                              offset: Offset(3, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Debito multe", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(sumFines(fines) + " €", style: TextStyle(fontSize: 17)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          elevation: 7
                        ),
                        child: Text("DETTAGLI", style: TextStyle(fontSize: 17)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FinesAthletePage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70, 35, 70, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onSurface: Colors.deepOrangeAccent,
                    elevation: 7,
                    padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Esci", style: TextStyle(color: Colors.white, fontSize: 22)),
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "trainer") ? getTrainerView() : getAthleteView();
  }

  String sumFines(List<Fine> fines) {
    int euro = 0;
    int cents = 0;
    for (var fine in fines) {
      euro += fine.euro;
      cents += fine.cents;
    }
    String debt = euro.toString() + "," + cents.toString().padRight(2, "0");
    return debt;
  }

}