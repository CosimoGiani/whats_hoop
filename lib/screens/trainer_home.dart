import 'package:flutter/material.dart';

class TrainerHome extends StatefulWidget {

  @override
  _TrainerHomeState createState() => _TrainerHomeState();
}

class _TrainerHomeState extends State<TrainerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Le tue squadre"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
