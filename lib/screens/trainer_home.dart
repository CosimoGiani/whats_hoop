import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/models/team.dart';
import 'package:whatshoop/screens/activities.dart';

class TrainerHome extends StatefulWidget {

  @override
  _TrainerHomeState createState() => _TrainerHomeState();

}

class _TrainerHomeState extends State<TrainerHome> {

  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  final _authUser = FirebaseAuth.instance.currentUser;
  late TextEditingController nameController;
  List<Team?> teams = [];
  bool isVisible = false;
  bool modify = true;
  final DatabaseService service = new DatabaseService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Le tue squadre"), centerTitle: true, automaticallyImplyLeading: false),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text("Le tue squadre"),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () => setState(() => (isVisible = !isVisible) & (modify = !modify)),
                child: modify ? Text("RIMUOVI") : Text("FATTO"),
                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () async {
              final team = await showCreationDialog();
              setState(() => teams.add(team));
            },
          ),
          body: teams.isEmpty
              ? Center(child: Text("Non hai ancora creato nessuna squadra", style: TextStyle(fontSize: 18)))
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  itemCount: teams.length,
                  itemBuilder: (_, i) => createCard(teams, i),
                  separatorBuilder: (context, index) => SizedBox(height: 20)
                ),
        );
      }
    );
  }

  createCard(List<Team?> teams, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    color: Colors.white,
    child: InkWell(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teams[i]!.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(teams[i]!.numPartecipants.toString(), style: TextStyle(fontSize: 18)),
                    Text(" PARTECIPANTI", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: isVisible,
              child: Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    await service.removeTeam(teams[i], _authUser!.uid);
                    setState(() => teams.remove(teams[i]));
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.cancel_rounded, color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (isVisible) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Activities()));
      },
    ),
  );

  Future<Team?> showCreationDialog() => showDialog<Team>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                Text(
                  "Crea squadra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Inserisci il nome della tua squadra",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Inserire un nome valido";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nameController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Nome squadra",
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrangeAccent,
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    onPressed: () {
                      addNewTeam();
                    },
                    child: Text(
                      "Crea",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
  );

  Future<void> _loadData() async {
    String trainerID = _authUser!.uid.toString();
    List<Team> teamsUser = await service.getTeamsFromTrainerID(trainerID);
    teams = teamsUser;
  }

  Future addNewTeam() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String trainerID = _authUser!.uid.toString();
      await firestoreInstance.collection("teams").add({
        "name": nameController.text,
        "numPartecipants": "0",
        "trainerID": trainerID,
      });
      Team team = Team(name: name, numPartecipants: 0, trainerID: trainerID);
      Navigator.of(context).pop(team);
    }
  }

}