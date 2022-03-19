import 'package:whatshoop/models/user.dart' as Player;
import 'package:flutter/material.dart';
import 'package:whatshoop/models/team.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/screens/fines.dart';

class TeamManagement extends StatefulWidget {

  String teamID;
  String mode;
  TeamManagement(this.teamID, this.mode);

  @override
  _TeamManagementState createState() => _TeamManagementState();

}

class _TeamManagementState extends State<TeamManagement> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  //List<Team?> teams = [];
  late Player.UserModel trainer;
  final DatabaseService service = new DatabaseService();
  late TextField newInvite;
  bool initialization = false;
  List<Player.UserModel> players = [];

  Future _loadData(String teamID) async {
    List<Player.UserModel> playersToLoad = await service.getPlayersFromTeamID(teamID);
    players = playersToLoad;
    initialization = true;
    Team team = await service.getTeamFromID(teamID);
    trainer = await service.getUserFromID(team.trainerID);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getTrainerView() {
    return FutureBuilder(
        future: _loadData(widget.teamID),
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
                  SizedBox(height: 20),
                  Container(
                    color: Colors.orange.shade500,
                    alignment: Alignment.center,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text("AGGIUNGI ATLETA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  // INVITO
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: Material(
                      elevation: 15,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                            child: Row(
                              children: [
                                // CAMPO AGGIUNGI EMAIL
                                Expanded(
                                  flex: 9,
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
                                // BOTTONO ADD PLAYER
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 10,
                                          top: 9.5,
                                          child: Icon(Icons.person_add, color: Colors.black.withAlpha(150), size: 32),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await invitePlayer(emailController.text, widget.teamID);
                                            setState(() {
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
                    color: Colors.orange.shade500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text("LA TUA SQUADRA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget getAthleteView() {
    return FutureBuilder(
        future: _loadData(widget.teamID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !initialization) {
            return Scaffold(
              appBar: AppBar(title: Text("La squadra"),
                  centerTitle: false,
                  automaticallyImplyLeading: false
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Text("La squadra"),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    color: Colors.orange.shade500,
                    alignment: Alignment.center,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text("Allenatore", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  // ALLENATORE
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: Material(
                      elevation: 15,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
                            child: Row(
                              children: [
                                Text("${trainer.firstName} ${trainer.lastName}", style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          )
                      ),
                    ),
                  ),
                  // ATLETI
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.orange.shade500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text("Atleti", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        itemBuilder: (_, i) => createCardAthlete(players, i),
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

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "trainer") ? getTrainerView() : getAthleteView();
  }

  Future invitePlayer(String email, String teamID) async {
    if (_formKey.currentState!.validate()) {
      try {
        Player.UserModel player = await service.getUserFromEmail(email);
        await service.sendInvite(teamID, player.id);
      } on RangeError catch (e) {
        print(e);
        showErrorSnackBar(context, "Nessun utente corrisponde a questa email.");
      }
    }
  }

  Future removePlayer(String userID, String teamID) async {
    await service.removeAthleteFromTeam(userID, teamID);
  }

  void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_outlined, size: 32, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.deepOrangeAccent,
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.fixed,
    );
    Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
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
                  left: 10,
                  top: 9.5,
                  child: Icon(Icons.attach_money_sharp, color: Colors.black.withAlpha(150), size: 35),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Fines(players[i].id)));
                  },
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
                  left: 10,
                  top: 9.5,
                  child: Icon(Icons.person_remove, color: Colors.black.withAlpha(150), size: 32),
                ),
                IconButton(
                  onPressed: () {
                    showRemoveDialog(players[i].id);
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

  createCardAthlete(List<Player.UserModel> players, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 15, 0, 15),
      child: Row(
        children: [
          // NOME GIOCATORE
          Expanded(
            flex: 8,
            child: Text("${players[i].firstName} ${players[i].lastName}", style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    ),
  );

  Future showRemoveDialog(String userID) => showDialog(
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
                      minWidth: MediaQuery.of(context).size.width * 0.2,
                      onPressed: () async {
                        await removePlayer(userID, widget.teamID);
                      },
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

}