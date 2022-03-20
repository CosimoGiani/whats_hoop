import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whatshoop/database_service.dart';

class SurveyPage extends StatefulWidget {

  Survey survey;
  String mode;
  SurveyPage(this.survey, this.mode);

  @override
  _SurveyPageState createState() => _SurveyPageState();

}

class _SurveyPageState extends State<SurveyPage> {

  bool value = false;
  final authUser = FirebaseAuth.instance.currentUser;
  late List<ChartData> chartData;
  final DatabaseService service = new DatabaseService();
  List<int> votes = [];
  List<CheckBoxState> optionsToDisplay = [];
  bool firstTime = true;
  bool voting = false;

  Future _loadData(Survey survey) async {
    votes = await service.getSurveyVotes(survey);
    chartData = getVotesChartData(votes, survey);
    if (firstTime) {
      for (var element in survey.options) {
        optionsToDisplay.add(CheckBoxState(title: element));
      }
      firstTime = false;
    }
  }

  Future _loadDataAthlete(Survey survey) async {
    votes = await service.getSurveyVotes(survey);
    chartData = getVotesChartData(votes, survey);
    if (firstTime) {
      for (var element in survey.options) {
        if (await service.getCheckboxValue(survey, authUser!.uid, element)) {
          optionsToDisplay.add(CheckBoxState(title: element, value: true));
        } else {
          optionsToDisplay.add(CheckBoxState(title: element));
        }
      }
      firstTime = false;
    }
  }

  List<ChartData> getVotesChartData(List<int> votes, Survey survey) {
    List<ChartData> list = [];
    for (int i = 0; i < votes.length; i++) {
      list.add(ChartData(survey.options[i], votes[i]));
    }
    return list;
  }

  Widget getTrainerView() {
    return FutureBuilder(
      future: _loadData(widget.survey),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(""),
            automaticallyImplyLeading: true,
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  // TITOLO
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                        widget.survey.title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  ),
                  // DOMANDA
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      widget.survey.question,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // OPZIONI
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (_, i) => createCheckboxList(widget.survey.options, i),
                    separatorBuilder: (context, index) => SizedBox(height: 1),
                    itemCount: widget.survey.options.length,
                  ),
                  SizedBox(height: 15),
                  // GRAFICO
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Risultati",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 350,
                    child: widget.survey.numVotes == 0
                      ? Center(child: Text("Nessun giocatore ha ancora votato", style: TextStyle(fontSize: 20)))
                      : SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: TextStyle(fontSize: 15),
                        overflowMode: LegendItemOverflowMode.wrap,
                        iconWidth: 25,
                        iconHeight: 25,
                        itemPadding: 15,
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.answer,
                          yValueMapper: (ChartData data, _) => data.vote,
                          //explode: true,
                          dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getAthleteView() {
    return FutureBuilder(
      future: _loadDataAthlete(widget.survey),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text(""),
            automaticallyImplyLeading: true,
          ),
          body: Builder(
            builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  // TITOLO
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                        widget.survey.title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  ),
                  // DOMANDA
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      widget.survey.question,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // OPZIONI
                  ...optionsToDisplay.map(buildSingleCheckbox).toList(),
                  SizedBox(height: 15),
                  // GRAFICO
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Risultati",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 350,
                    child: SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: TextStyle(fontSize: 15),
                        overflowMode: LegendItemOverflowMode.wrap,
                        iconWidth: 25,
                        iconHeight: 25,
                        itemPadding: 15,
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.answer,
                          yValueMapper: (ChartData data, _) => data.vote,
                          //explode: true,
                          dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _updateVotes(CheckBoxState checkbox, bool value) async {
    await service.userVote(widget.survey, authUser!.uid, checkbox.title, value);
    setState(() {
      if (checkbox.value) {
        for (var element in optionsToDisplay) {
          element.value = value;
          checkbox.value = value;
        }
      } else {
        for (var element in optionsToDisplay) {
          if (element.title != checkbox.title) {
            element.value = !value;
          } else {
            checkbox.value = value;
          }
        }
      }
    });
  }

  Widget buildSingleCheckbox(CheckBoxState checkbox) => CheckboxListTile(
    value: checkbox.value,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(checkbox.title, style: TextStyle(fontSize: 20)),
    onChanged: (value) async {
      /*setState(() {
        if (checkbox.value) {
          for (var element in optionsToDisplay) {
            element.value = value!;
            checkbox.value = value;
          }
        } else {
          for (var element in optionsToDisplay) {
            if (element.title != checkbox.title) {
              element.value = !value!;
            } else {
              checkbox.value = value!;
            }
          }
        }
      });*/
      await _updateVotes(checkbox, value!);
      //await service.userVote(widget.survey, authUser!.uid, checkbox.title, checkbox.value);
    },
  );

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "trainer") ? getTrainerView() : getAthleteView();
  }

  createCheckboxList(List<String> options, int i) => CheckboxListTile(
    controlAffinity: ListTileControlAffinity.leading,
    value: value,
    title: Text(widget.survey.options[i], style: TextStyle(fontSize: 20)),
    onChanged: (value) {}
  );

}

class CheckBoxState {
  final String title;
  bool value;

  CheckBoxState({
    required this.title,
    this.value = false,
});
}

class ChartData {
  ChartData(this.answer, this.vote);
  final String answer;
  final int vote;
}
