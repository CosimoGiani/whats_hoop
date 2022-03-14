import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whatshoop/database_service.dart';

class SurveyPage extends StatefulWidget {

  Survey survey;
  SurveyPage(this.survey);

  @override
  _SurveyPageState createState() => _SurveyPageState();

}

class _SurveyPageState extends State<SurveyPage> {

  bool value = false;
  late List<ChartData> chartData;
  final DatabaseService service = new DatabaseService();
  List<int> votes = [];

  Future _loadData(Survey survey) async {
    votes = await service.getSurveyVotes(survey);
    chartData = getVotesChartData(votes, survey);
  }

  List<ChartData> getVotesChartData(List<int> votes, Survey survey) {
    List<ChartData> list = [];
    for (int i = 0; i < votes.length; i++) {
      list.add(ChartData(survey.options[i], votes[i]));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
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

  createCheckboxList(List<String> options, int i) => CheckboxListTile(
    controlAffinity: ListTileControlAffinity.leading,
    value: value,
    title: Text(widget.survey.options[i], style: TextStyle(fontSize: 20)),
    onChanged: (value) {}
  );

}

class ChartData {
  ChartData(this.answer, this.vote);
  final String answer;
  final int vote;
}
