import 'package:flutter/material.dart';

class FinesAthletePage extends StatefulWidget {

  @override
  _FinesAthletePageState createState() => _FinesAthletePageState();

}

class _FinesAthletePageState extends State<FinesAthletePage> {

  Future _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Le tue multe"),
                centerTitle: true,
                automaticallyImplyLeading: true,
              ),
              body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Le tue multe"),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
          //body: ,
        );
      },
    );
  }

}