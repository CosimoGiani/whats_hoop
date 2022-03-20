import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/models/activity.dart';
import 'package:whatshoop/screens/main_page.dart';

class NewActivity extends StatefulWidget {

  late String teamID;
  late String mode;
  late Activity activity;
  NewActivity(this.teamID, this.mode);
  NewActivity.modify(this.teamID, this.mode, this.activity);

  @override
  _NewActivityState createState() => _NewActivityState();

}

class _NewActivityState extends State<NewActivity> {

  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  String dateToDisplay = "";
  final types = ["Allenamento", "Partita"];
  String? value;
  String timeToDisplay = "";
  final initialTime = const TimeOfDay(hour: 0, minute: 0);
  String placeToDisplay = "";
  String notesToDisplay = "(Facoltativo)";
  final TextEditingController placeController = new TextEditingController();
  final TextEditingController notesController = new TextEditingController();
  final DatabaseService service = new DatabaseService();
  bool isToday = false;
  bool hourSelectedNow = false;

  @override
  void initState() {
    if (widget.mode == "modify") {
      value = widget.activity.type;
      dateToDisplay = widget.activity.date;
      timeToDisplay = widget.activity.time;
      placeToDisplay = widget.activity.place;
      notesToDisplay = widget.activity.notes;
    }
    super.initState();
  }

  Widget getCreateView() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Aggiungi un'attività"),
        centerTitle: true,
      ),
      body: Builder(builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 25),
                child: Column(
                  children: <Widget>[
                    // TIPO
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
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
                                  onChanged: (value) {setState(() => this.value = value);},
                                ),
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
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              //width: 240,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 17),
                                      child: Text(
                                        "$dateToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          //locale: const Locale("it", "IT"),
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(Duration(days: 0)),
                                          lastDate: DateTime(DateTime.now().year + 5),
                                        ).then((date) {
                                          if (DateFormat("dd/MM/yyy").format(date!) == DateFormat("dd/MM/yyy").format(DateTime.now())) {
                                            setState(() {
                                              isToday = true;
                                            });
                                          }
                                          setState(() {
                                            dateToDisplay = DateFormat("dd/MM/yyy").format(date);
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.event, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    // ORARIO
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              //width: 240,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 17),
                                      child: Text(
                                        "$timeToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: initialTime,
                                        ).then((time) {
                                          if (time!.hour < DateTime.now().hour) {
                                            setState(() {
                                              hourSelectedNow = true;
                                            });
                                          }
                                          setState(() {
                                            timeToDisplay = adjusteTime(time);
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.more_time, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                  /*Padding(
                                        padding: EdgeInsets.fromLTRB(122, 0, 0, 0),
                                        child: IconButton(
                                          onPressed: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: initialTime,
                                            ).then((time) {
                                              if (time!.hour < DateTime.now().hour) {
                                                setState(() {
                                                  hourSelectedNow = true;
                                                });
                                              }
                                              setState(() {
                                                timeToDisplay = adjusteTime(time);
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.more_time, color: Colors.deepOrangeAccent, size: 25),
                                        ),
                                      ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    // LUOGO
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                      height: 35,
                      child: Row(
                        children: [
                          Icon(Icons.map_outlined, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                              "LUOGO",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(height: 7),
                    Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                                      child: Text(
                                        "$placeToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: IconButton(
                                    onPressed: () async {
                                      final place = await showPlaceDialog();
                                      setState(() => placeToDisplay = place!);
                                    },
                                    icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    // NOTE
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                      height: 35,
                      child: Row(
                        children: [
                          Icon(Icons.speaker_notes, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                              "NOTE",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(height: 7),
                    Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(10),
                        child: Flex(
                            direction: Axis.horizontal,
                            children:[ Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                                        child: Text(
                                          "$notesToDisplay",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: IconButton(
                                      onPressed: () async {
                                        final notes = await showNotesDialog();
                                        setState(() => notesToDisplay = notes!);
                                      },
                                      icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),])
                    ),
                    SizedBox(height: 35),
                    // BOTTONE AGGIUNGI
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.deepOrangeAccent,
                        elevation: 10,
                        padding: EdgeInsets.fromLTRB(50, 17, 50, 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Aggiungi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () async {
                        if(placeToDisplay.isEmpty || value!.isEmpty || dateToDisplay.isEmpty || timeToDisplay.isEmpty) {
                          showErrorSnackBar(context, "Per favore inserire tutti i campi necessari ('Note' facoltativo).");
                        } else if (isToday && hourSelectedNow) {
                          setState(() {
                            showErrorSnackBar(context, "Evento non programmato. Orario già passato.");
                            dateToDisplay = "";
                            timeToDisplay = "";
                            isToday = false;
                            hourSelectedNow = false;
                          });
                        } else {
                          Activity activity = await service.addNewActivity(widget.teamID, value!, dateToDisplay, timeToDisplay, placeController, notesController);
                          Navigator.of(context).pop(activity);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),),
    );
  }

  Widget getModifyView() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Modifica l'attività"),
        centerTitle: true,
      ),
      body: Builder(builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 25),
                child: Column(
                  children: <Widget>[
                    // TIPO
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
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
                                  onChanged: (value) {setState(() => this.value = value);},
                                ),
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
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              //width: 240,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 17),
                                      child: Text(
                                        "$dateToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          //locale: const Locale("it", "IT"),
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now().subtract(Duration(days: 0)),
                                          lastDate: DateTime(DateTime.now().year + 5),
                                        ).then((date) {
                                          if (DateFormat("dd/MM/yyy").format(date!) == DateFormat("dd/MM/yyy").format(DateTime.now())) {
                                            setState(() {
                                              isToday = true;
                                            });
                                          }
                                          setState(() {
                                            dateToDisplay = DateFormat("dd/MM/yyy").format(date);
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.event, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    // ORARIO
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrangeAccent,
                            ),
                            height: 35,
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
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              //width: 240,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 17),
                                      child: Text(
                                        "$timeToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      onPressed: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: initialTime,
                                        ).then((time) {
                                          if (time!.hour < DateTime.now().hour) {
                                            setState(() {
                                              hourSelectedNow = true;
                                            });
                                          }
                                          setState(() {
                                            timeToDisplay = adjusteTime(time);
                                          });
                                        });
                                      },
                                      icon: Icon(Icons.more_time, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    // LUOGO
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                      height: 35,
                      child: Row(
                        children: [
                          Icon(Icons.map_outlined, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                              "LUOGO",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(height: 7),
                    Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                                      child: Text(
                                        "$placeToDisplay",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: IconButton(
                                    onPressed: () async {
                                      final place = await showPlaceDialog();
                                      setState(() => placeToDisplay = place!);
                                    },
                                    icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    // NOTE
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrangeAccent,
                      ),
                      height: 35,
                      child: Row(
                        children: [
                          Icon(Icons.speaker_notes, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                              "NOTE",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(height: 7),
                    Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(10),
                        child: Flex(
                            direction: Axis.horizontal,
                            children:[ Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                                        child: Text(
                                          "$notesToDisplay",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: IconButton(
                                      onPressed: () async {
                                        final notes = await showNotesDialog();
                                        setState(() => notesToDisplay = notes!);
                                      },
                                      icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),])
                    ),
                    SizedBox(height: 35),
                    // BOTTONE SALVA
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onSurface: Colors.deepOrangeAccent,
                        elevation: 10,
                        padding: EdgeInsets.fromLTRB(50, 17, 50, 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Salva",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () async {
                        if(placeToDisplay.isEmpty || value!.isEmpty || dateToDisplay.isEmpty || timeToDisplay.isEmpty) {
                          showErrorSnackBar(context, "Per favore inserire tutti i campi necessari ('Note' facoltativo).");
                        } else if (isToday && hourSelectedNow) {
                          setState(() {
                            showErrorSnackBar(context, "Evento non programmato. Orario già passato.");
                            dateToDisplay = "";
                            timeToDisplay = "";
                            isToday = false;
                            hourSelectedNow = false;
                          });
                        } else {
                          await service.updateModifiedActivity(widget.activity, value!, dateToDisplay, timeToDisplay, placeToDisplay, notesToDisplay);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(widget.teamID, "trainer")));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "create") ? getCreateView() : getModifyView();
  }

  void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.error_outline_outlined, size: 32, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      backgroundColor: Colors.deepOrangeAccent,
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.fixed,
    );
    Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
  }

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem(
    value: type,
    child: Text(
      type,
      style: TextStyle(fontSize: 20),
    ),
  );

  String adjusteTime(TimeOfDay time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString();
    if (hour.length == 1 ) {
      hour = time.hour.toString().padLeft(2, "0");
    }
    if (minute.length == 1) {
      minute = time.minute.toString().padLeft(2, "0");
    }
    return hour + ":" + minute;
  }

  Future<String?> showPlaceDialog() => showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "Luogo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Inserisci il luogo dove si terrà l'evento",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: placeController,
                  onSaved: (value) {
                    placeController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Luogo evento",
                  ),
                ),
              ),
              SizedBox(height: 15),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepOrangeAccent,
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: () {
                    Navigator.of(context).pop(placeController.text);
                  },
                  child: Text(
                    "Salva",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    ),
  );

  Future<String?> showNotesDialog() => showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "Note aggiuntive",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Qualcosa da aggiungere? Scrivi qui",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: notesController,
                  onSaved: (value) {
                    notesController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Note",
                  ),
                ),
              ),
              SizedBox(height: 15),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepOrangeAccent,
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: () {
                    Navigator.of(context).pop(notesController.text);
                  },
                  child: Text(
                    "Salva",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    ),
  );

}