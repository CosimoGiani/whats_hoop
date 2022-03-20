import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'package:whatshoop/screens/new_survey.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/screens/survey_page.dart';

class Surveys extends StatefulWidget {

  String teamID;
  String mode;
  Surveys(this.teamID, this.mode);

  @override
  _SurveysState createState() => _SurveysState();

}

class _SurveysState extends State<Surveys> {

  bool isVisible = false;
  bool remove = true;
  List<Survey> activeSurveys = [];
  final DatabaseService service = new DatabaseService();
  static const itemRemove = MenuItem(text: "Elimina", icon: Icons.delete);
  static const List<MenuItem> items = [itemRemove];

  Future _loadData(String teamID) async {
    List<Survey> surveys = await service.getSurveysByTeamID(teamID);
    activeSurveys = surveys;
  }

  Widget getTrainerView() {
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
              remove
              ? PopupMenuButton<MenuItem>(
                onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    ...items.map(buildItem).toList(),
                  ],
              )
              : FlatButton(
                textColor: Colors.white,
                onPressed: () => setState(() => (isVisible = !isVisible) & (remove = !remove)),
                child: remove ? Text("RIMUOVI") : Text("FATTO"),
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

  Widget getAthleteView() {
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
          ),
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

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "trainer") ? getTrainerView() : getAthleteView();
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

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case itemRemove:
        setState(() => (isVisible = !isVisible) & (remove = !remove));
        break;
    }
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
                    SizedBox(width: 15),
                    Text(surveys[i].numVotes.toString(), style: TextStyle(fontSize: 18)),
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
                    await service.removeSurvey(surveys[i].id);
                    setState(() => surveys.remove(surveys[i]));
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyPage(surveys[i], widget.mode)));
      },
    ),
  );

}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({required this.text, required this.icon});
}
