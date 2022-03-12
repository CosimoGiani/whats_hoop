import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'package:whatshoop/screens/new_survey.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/screens/survey_page.dart';

class Surveys extends StatefulWidget {

  String teamID;
  Surveys(this.teamID);

  @override
  _SurveysState createState() => _SurveysState();

}

class _SurveysState extends State<Surveys> {

  bool isVisible = false;
  bool modify = true;
  List<Survey> activeSurveys = [];
  final DatabaseService service = new DatabaseService();

  Future _loadData(String teamID) async {
    // TODO caricare tutti i sondaggi ancora attivi
    List<Survey> surveys = await service.getSurveysByTeamID(teamID);
    activeSurveys = surveys;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(widget.teamID),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Sondaggi"),
                centerTitle: false,
                automaticallyImplyLeading: false
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Sondaggi"),
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
          floatingActionButton: !isVisible ? FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () async {
              final survey = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewSurvey(widget.teamID)));
              setState(() => activeSurveys.add(survey));
            },
          ) : null,
          body: activeSurveys.isEmpty
              ? Center(child: Text("Nessuna sondaggio attivo", style: TextStyle(fontSize: 18)))
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                  itemCount: activeSurveys.length,
                  itemBuilder: (_, i) => createCard(activeSurveys, i),
                  separatorBuilder: (context, index) => SizedBox(height: 20)
          ),
        );
      },
    );
  }

  createCard(List<Survey> surveys, int i) => Card(
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
                Text(surveys[i].title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                Row(
                  children: [
                    Icon(Icons.chat_outlined),
                    //Text(, style: TextStyle(fontSize: 18)),
                    Text(" RISPOSTE", style: TextStyle(fontSize: 18)),
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
                    //await service.removeTeam(teams[i]!.id);
                    //setState(() => teams.remove(teams[i]));
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyPage()));
      },
    ),
  );

}

