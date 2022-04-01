import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/database_service.dart';
import 'package:whatshoop/models/fine.dart';

class FinesAthletePage extends StatefulWidget {

  @override
  _FinesAthletePageState createState() => _FinesAthletePageState();

}

class _FinesAthletePageState extends State<FinesAthletePage> {

  List<Fine> finesToDisplay = [];
  final DatabaseService service = new DatabaseService();
  final authUser = FirebaseAuth.instance.currentUser;

  Future _loadData() async {
    finesToDisplay = await service.getFinesFromPlayerID(authUser!.uid);
  }

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
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Debito totale: ", style: TextStyle(fontSize: 20)),
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(sumFines(finesToDisplay) + " €", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: finesToDisplay.isEmpty
                    ? SizedBox(height: 100,child: Center(child: Text("Non hai multe! Bravo!", style: TextStyle(fontSize: 18))))
                    : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                    itemCount: finesToDisplay.length,
                    itemBuilder: (_, i) => createCard(finesToDisplay, i),
                    separatorBuilder: (context, index) => SizedBox(height: 10)
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  createCard(List<Fine> fines, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  finesToDisplay[i].reason,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2.5),
                    },
                    border: TableBorder.all(color: Colors.white),
                    children: [
                      TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Importo:", style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(finesToDisplay[i].euro.toString() + "," + adjusteCents(finesToDisplay[i].cents) + " €", style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                      TableRow(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text("Data:", style: TextStyle(fontSize: 20)),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(finesToDisplay[i].date, style: TextStyle(fontSize: 20)),
                            ),
                          ]
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );

  String adjusteCents(int centsToAdjuste) {
    String cents = centsToAdjuste.toString();
    if (cents.length == 1) {
      cents = centsToAdjuste.toString().padRight(2, "0");
    }
    return cents;
  }

  String sumFines(List<Fine> fines) {
    int euro = 0;
    int cents = 0;
    for (var fine in fines) {
      euro += fine.euro;
      cents += fine.cents;
    }
    String debt = euro.toString() + "," + cents.toString().padRight(2, "0");
    return debt;
  }

}