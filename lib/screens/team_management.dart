import 'package:flutter/material.dart';

class TeamManagement extends StatefulWidget {

  @override
  _TeamManagementState createState() => _TeamManagementState();

}

class _TeamManagementState extends State<TeamManagement> {

  Future _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Squadra"),
                centerTitle: false,
                automaticallyImplyLeading: false
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Text("Squadra"),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
        );
      }
    );
  }


}