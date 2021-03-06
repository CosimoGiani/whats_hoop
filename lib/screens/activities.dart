import 'package:flutter/material.dart';
import 'package:whatshoop/models/activity.dart';
import 'package:whatshoop/screens/new_activity.dart';
import 'package:whatshoop/database_service.dart';
import 'package:intl/intl.dart';

class Activities extends StatefulWidget {

  String teamID;
  String mode;
  Activities(this.teamID, this.mode);

  @override
  _ActivitiesState createState() => _ActivitiesState();

}

class _ActivitiesState extends State<Activities> {

  List<Activity> scheduledActivities = [];
  bool isVisible = false;
  bool remove = true;
  bool modify = false;
  final DatabaseService service = new DatabaseService();
  static const itemRemove = MenuItem(text: "Elimina", icon: Icons.delete);
  static const itemModify = MenuItem(text: "Modifica", icon: Icons.auto_fix_high);
  static const List<MenuItem> items = [itemRemove, itemModify];

  Future _loadData(String teamID) async {
    List<Activity> activities = await service.getActivitiesByTeamID(teamID);
    var toRemove = [];
    for (var activity in activities) {
      if (isExpired(activity)) {
        toRemove.add(activity);
        await service.removeActivity(activity.id);
      }
    }
    activities.removeWhere((element) => toRemove.contains(element));
    scheduledActivities = activities;
  }

  bool isExpired(Activity activity) {
    DateTime dateTime = DateTime.now();
    String day = DateFormat("dd/MM/yyy").format(dateTime);
    int activityHour = int.parse(activity.time.substring(0,2));
    int activityMinute = int.parse(activity.time.substring(3,5));
    if (activity.date == day) {
      if (activityHour <= dateTime.hour) {
        if (activityMinute <= dateTime.minute) {
          return true;
        }
      }
    }
    if (int.parse(activity.date.substring(0,2)) < int.parse(day.substring(0,2))) {
      return true;
    }
    return false;
  }

  Widget getAthleteView() {
    return FutureBuilder(
        future: _loadData(widget.teamID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: Text("Attivit?? programmate"), centerTitle: false, automaticallyImplyLeading: false),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Text("Attivit?? programmate"),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: scheduledActivities.isEmpty
                ? Center(child: Text("Nessuna attivit?? programmata", style: TextStyle(fontSize: 18)))
                : ListView.separated(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                itemCount: scheduledActivities.length,
                itemBuilder: (_, i) => createCard(scheduledActivities, i),
                separatorBuilder: (context, index) => SizedBox(height: 20)
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.mode == "trainer") ? getTrainerView() : getAthleteView();
  }

  Widget getTrainerView() {
    return FutureBuilder(
        future: _loadData(widget.teamID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: Text("Attivit?? programmate"), centerTitle: false, automaticallyImplyLeading: false),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Text("Attivit?? programmate"),
              centerTitle: false,
              automaticallyImplyLeading: false,
              actions: [
                remove ? // remove = true di default
                PopupMenuButton<MenuItem>(
                  onSelected: (item) => onSelected(context, item),
                  itemBuilder: (context) => [
                    ...items.map(buildItem).toList(),
                  ],
                )
                : !modify ?
                FlatButton(
                    textColor: Colors.white,
                    onPressed: () => setState(() => (isVisible = !isVisible) & (remove = !remove)),
                    child: Text("FATTO"),
                    shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                )
                : FlatButton(
                  textColor: Colors.white,
                  onPressed: () => setState(() => (isVisible = !isVisible) & (modify = !modify) & (remove = !remove)),
                  child: Text("FATTO"),
                  shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                ),
              ],
            ),
            floatingActionButton: !isVisible ? FloatingActionButton(
              elevation: 10,
              child: Icon(Icons.add),
              onPressed: () async {
                final activity = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewActivity(widget.teamID, "create")));
                setState(() => scheduledActivities.add(activity));
              },
            ) : null,
            body: scheduledActivities.isEmpty
                ? Center(child: Text("Nessuna attivit?? programmata", style: TextStyle(fontSize: 18)))
                : ListView.separated(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                itemCount: scheduledActivities.length,
                itemBuilder: (_, i) => createCardTrainer(scheduledActivities, i),
                separatorBuilder: (context, index) => SizedBox(height: 20)
            ),
          );
        }
    );
  }

  createCard(List<Activity> activities, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  scheduledActivities[i].type.toString() + " - " + scheduledActivities[i].date,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 13),
              Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3.2),
                    },
                    border: TableBorder.all(color: Colors.white),
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text("Orario:", style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(scheduledActivities[i].time, style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text("Luogo:", style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(scheduledActivities[i].place, style: TextStyle(fontSize: 20)),
                          ),
                        ]
                      ),
                      TableRow(
                          children: [
                            Text("Note:", style: TextStyle(fontSize: 20)),
                            Text(scheduledActivities[i].notes, style: TextStyle(fontSize: 20)),
                          ]
                      ),
                    ],
                  ),
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
                  await service.removeActivity(scheduledActivities[i].id);
                  setState(() => activities.remove(activities[i]));
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
  );

  createCardTrainer(List<Activity> activities, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  scheduledActivities[i].type.toString() + " - " + scheduledActivities[i].date,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 13),
              Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3.2),
                    },
                    border: TableBorder.all(color: Colors.white),
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text("Orario:", style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 7),
                            child: Text(scheduledActivities[i].time, style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      TableRow(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 7),
                              child: Text("Luogo:", style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 7),
                              child: Text(scheduledActivities[i].place, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                      TableRow(
                          children: [
                            Text("Note:", style: TextStyle(fontSize: 20)),
                            Text(scheduledActivities[i].notes, style: TextStyle(fontSize: 20)),
                          ]
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Positioned(
              right: 0.0,
              child: !modify ?
              GestureDetector(
                onTap: () async {
                  await service.removeActivity(scheduledActivities[i].id);
                  setState(() => activities.remove(activities[i]));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.cancel_rounded, color: Colors.deepOrange),
                ),
              )
              : GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewActivity.modify(widget.teamID, "modify", scheduledActivities[i])));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.auto_fix_high, color: Colors.deepOrange),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

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
      case itemModify:
        setState(() => (isVisible = !isVisible) & (modify = !modify) & (remove = !remove));
        break;
    }
  }

}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({required this.text, required this.icon});
}