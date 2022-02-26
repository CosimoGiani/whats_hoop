import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatshoop/models/user.dart' as Player;
import 'package:flutter/material.dart';
import 'package:whatshoop/models/team.dart';
import 'package:whatshoop/database_service.dart';

class TeamManagement extends StatefulWidget {

  String teamID;
  TeamManagement(this.teamID);

  @override
  _TeamManagementState createState() => _TeamManagementState();

}

class _TeamManagementState extends State<TeamManagement> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final _authUser = FirebaseAuth.instance.currentUser;
  List<Team?> teams = [];
  final DatabaseService service = new DatabaseService();
  late TextField newInvite;
  bool initialization = false;
  List<Player.UserModel> players = [Player.UserModel(
      id: FirebaseAuth.instance.currentUser!.uid,
      email: "prova@mail.com", firstName: "Prova", lastName: "Test", type: 2)];

  Future _loadData() async {
    String trainerID = _authUser!.uid.toString();
    List<Team> teamsUser = await service.getTeamsFromTrainerID(trainerID);
    teams = teamsUser;
    // TODO caricare i giocatori della squadra, tipo getTeamPlayers()
    initialization = true;
  }

  @override
  void initState() {
    //_buildTextFieldInvite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done && !initialization) {
          return Scaffold(
            appBar: AppBar(title: Text("Gestisci la tua squadra"),
                centerTitle: false,
                automaticallyImplyLeading: false
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Gestisci la tua squadra"),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // AGGIUNGI ATLETA
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text("Aggiungi atleta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // INVITO
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                  child: Material(
                    elevation: 15,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              //height: 100,
                              width: 300,
                              child: TextFormField(
                                autofocus: false,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Per favore inserire una mail");
                                  }
                                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                    return ("Per favore inserire una mail valida");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                },
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10),
                                  hintText: "Inserisci email atleta...",
                                ),
                              ),
                            ),
                            //SizedBox(width: 1),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              //color: Colors.lightBlue,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 9.8,
                                    top: 9.5,
                                    child: Icon(Icons.person_add, color: Colors.black.withAlpha(150), size: 32),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        inviteUser(emailController.text, widget.teamID);
                                        emailController.text = "";
                                      });
                                    },
                                    icon: Icon(Icons.person_add),
                                    color: Colors.deepOrangeAccent,
                                    iconSize: 32,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
                // LA TUA SQUADRA
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text("La tua squadra", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // LISTA GIOCATORI
                Container(
                  child: players.isEmpty
                       ? SizedBox(height: 300, child: Center(child: Text("Nessun giocatore invitato", style: TextStyle(fontSize: 18))))
                       : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                          itemCount: players.length,
                          itemBuilder: (_, i) => createCard(players, i),
                          separatorBuilder: (context, index) => SizedBox(height: 20)
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void inviteUser(String email, String teamID) async {
    if (_formKey.currentState!.validate()) {
      // TODO aggiungere SnackBar o toast message per dare un'info di qualche tipo all'utente riguardo l'invito
      Player.UserModel player = await service.getUserFromEmail(email);
      await service.sendInvite(teamID, player.id);
    }
  }

  void removeUser() {
    // TODO logica per rimuovere l'utente dalla squadra
  }

  createCard(List<Player.UserModel> players, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
      child: Row(
        children: [
          // NOME GIOCATORE
          Expanded(
            flex: 8,
            child: Text("${players[i].firstName} ${players[i].lastName}", style: TextStyle(fontSize: 20)),
          ),
          // ICONA MULTE
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  left: 9.8,
                  top: 9.5,
                  child: Icon(Icons.attach_money_sharp, color: Colors.black.withAlpha(150), size: 35),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.attach_money_sharp),
                  color: Colors.deepOrangeAccent,
                  iconSize: 35,
                )
              ],
            ),
          ),
          // ICONA RIMUOVI
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  left: 9.8,
                  top: 9.5,
                  child: Icon(Icons.person_remove, color: Colors.black.withAlpha(150), size: 32),
                ),
                IconButton(
                  onPressed: () {
                    showRemoveDialog();
                  },
                  icon: Icon(Icons.person_remove),
                  color: Colors.deepOrangeAccent,
                  iconSize: 32,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future showRemoveDialog() => showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "Rimuovi giocatore",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Sicuro di voler rimuovere questo giocatore?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepOrangeAccent,
                    child: MaterialButton(
                      //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      minWidth: MediaQuery.of(context).size.width * 0.2,
                      onPressed: () {},
                      child: Text(
                        "Sì",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepOrangeAccent,
                    child: MaterialButton(
                      //padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      minWidth: MediaQuery.of(context).size.width * 0.2,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "No",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
      ),
    ),
  );

  /*createCard(List<Team?> teams, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    color: Colors.white,
    child: InkWell(
      child: Container(
        padding: EdgeInsets.all(20),
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
          ],
        ),
      ),
      onTap: () {},
    ),
  );*/

  /*void _buildTextFieldInvite() {
    setState(() {
      newInvite = new TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          //contentPadding: EdgeInsets.fromLTRB(2, 5, 0, 0),
          hintText: "prova",
        ),
      );
    });
  }

  Widget _buildInviteWidget() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: newInvite,
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              alignment: Alignment.centerRight,
              onPressed: (){},
              icon: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }*/


}