import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewActivity extends StatefulWidget {

  @override
  _NewActivityState createState() => _NewActivityState();

}

class _NewActivityState extends State<NewActivity> {

  //int selectedValue = 0;
  //DateTime? _dateTime = DateTime.now();
  String day = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  final types = ["Allenamento", "Partita"];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Aggiungi un'attività"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        // TIPO
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepOrangeAccent,
                              ),
                              height: 50,
                              width: 120,
                              child: Row(
                                children: [
                                  Icon(Icons.sports_basketball, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                      "TIPO",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            SizedBox(width: 10),
                            Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 240,
                                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: value,
                                      iconSize: 30,
                                      isExpanded: true,
                                      icon: Icon(Icons.arrow_drop_down, color: Colors.deepOrangeAccent),
                                      items: types.map(buildMenuType).toList(),
                                      onChanged: (value) => setState(() => this.value = value),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 25),
                        // DATA
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepOrangeAccent,
                              ),
                              height: 50,
                              width: 120,
                              child: Row(
                                children: [
                                  Icon(Icons.event_note_sharp, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                      "DATA",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            SizedBox(width: 10),
                            Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 240,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        "$day/$month/$year",
                                        style: TextStyle(fontSize: 20),
                                    ),
                                    Padding(
                                      //padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      padding: EdgeInsets.fromLTRB(77, 0, 0, 0),
                                      child: IconButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            locale: const Locale("it", "IT"),
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2050),
                                          ).then((date) {
                                            setState(() {
                                              day = date!.day.toString();
                                              month = date.month.toString();
                                              year = date.year.toString();
                                            });
                                          });
                                        },
                                        icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // ORARIO
                        Container(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.deepOrangeAccent,
                                ),
                                height: 50,
                                width: 120,
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time_filled, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                        "ORARIO",
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                              SizedBox(width: 10),
                              Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  //height: 60,
                                  child: Row(
                                    children: [
                                      Text("ciao"),
                                      SizedBox(width: 50),
                                      Text("ciao")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem(
    value: type,
    child: Text(
      type,
      style: TextStyle(fontSize: 20),
    ),
  );

}