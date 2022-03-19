import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/models/team.dart';
import 'package:whatshoop/models/user.dart';
import 'package:whatshoop/screens/login.dart';
import 'package:whatshoop/screens/main_page.dart';

class AthleteHome extends StatefulWidget {

  @override
  _AthleteHomeState createState() => _AthleteHomeState();

}

class _AthleteHomeState extends State<AthleteHome> {

  bool hasInvitation = false;
  final DatabaseService service = new DatabaseService();
  final _authUser = FirebaseAuth.instance.currentUser;
  late Team team;
  static const itemLogout = MenuItem(text: "Esci", icon: Icons.logout);
  static const List<MenuItem> opt = [itemLogout];
  final auth = FirebaseAuth.instance;

  Future _loadData() async {
    if (await service.checkInvite(_authUser!.uid)) {
      hasInvitation = true;
      team = await service.getTeamInviteFromUserID(_authUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                  title: Text("Whats Hoop"),
                  centerTitle: true,
                  automaticallyImplyLeading: false),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Whats Hoop"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                PopupMenuButton<MenuItem>(
                  onSelected: (item) {
                    auth.signOut();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  itemBuilder: (context) => [
                    ...opt.map(buildItem).toList(),
                  ],
                ),
              ],
            ),
            body: !hasInvitation
                ? Center(child: Text("Non hai ancora ricevuto nessun invito", style: TextStyle(fontSize: 20)))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Hai ricevuto un invito per la squadra:", style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(team.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Vuoi accettare?", style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // TASTO ACCETTA
                                  Padding(
                                    padding: EdgeInsets.only(right: 40),
                                    child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                          color: Colors.green,
                                        ),
                                        width: MediaQuery.of(context).size.width/6,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Center(
                                            child: Icon(Icons.done_outline, color: Colors.white, size: 30),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        await service.acceptInvite(_authUser!.uid, team.id);
                                        UserModel userModel = await service.getUserFromID(_authUser!.uid);
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage(userModel.teamID!, "athlete")));
                                      },
                                    ),
                                  ),
                                  // TASTO RIFIUTA
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                        color: Colors.red,
                                      ),
                                      width: MediaQuery.of(context).size.width/6,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Center(
                                          child: Icon(Icons.remove_circle_outline, color: Colors.white, size: 30),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      await service.rejectInvite(_authUser!.uid, team.id);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AthleteHome()));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
    value: item,
    child: Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 20),
        const SizedBox(width: 12),
        Text(item.text)
      ],
    ),
  );

}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({required this.text, required this.icon});
}