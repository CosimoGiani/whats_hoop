import 'package:flutter/material.dart';
import 'package:whatshoop/screens/new_activity.dart';

class Activities extends StatefulWidget {

  /*Team? team;
  Activities({this.team});*/

  @override
  _ActivitiesState createState() => _ActivitiesState(/*team*/);

}

class _ActivitiesState extends State<Activities> {

  /*Team? team;
  _ActivitiesState(this.team);*/

  Future _loadData() async {return;}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Attività programmate"), centerTitle: false, automaticallyImplyLeading: false),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Attività programmate"),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 10,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewActivity()));
            },
          ),
        );
      }
    );
  }

}