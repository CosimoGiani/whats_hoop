import 'package:flutter/material.dart';
import 'package:whatshoop/screens/activities.dart';
import 'package:whatshoop/screens/surveys.dart';
import 'package:whatshoop/screens/team_management.dart';
import 'package:whatshoop/screens/trainer_profile.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Activities(),
    TeamManagement(),
    Surveys(),
    TrainerProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: size.height * 0.1,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: "Attività",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: "Squadra",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ballot_outlined),
              label: "Sondaggi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: "Profilo",
            ),
          ],
          iconSize: 30,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

}