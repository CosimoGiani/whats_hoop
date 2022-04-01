import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:whatshoop/models/fine.dart';
import 'package:whatshoop/database_service.dart';

class Fines extends StatefulWidget {

  String playerID;
  Fines(this.playerID);

  @override
  _FinesState createState() => _FinesState();

}

class _FinesState extends State<Fines> {

  final _formKey = GlobalKey<FormState>();
  String reasonToDisplay = "";
  final TextEditingController reasonController = new TextEditingController();
  final euro = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  final cents = ["00", "10", "20", "30", "40", "50", "60", "70", "80", "90"];
  int indexEuro = 0;
  int indexCents = 0;
  String euroText = "0";
  String centsText = "00";
  String dateToDisplay = "";
  List<Fine> finesToDisplay = [];
  final DatabaseService service = new DatabaseService();
  String debtToDisplay = "";
  bool initialization = false;

  Future _loadData(String playerID) async {
    List<Fine> fines = await service.getFinesFromPlayerID(playerID);
    finesToDisplay = fines;
    debtToDisplay = sumFines(fines);
    initialization = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadData(widget.playerID),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !initialization) {
            return Scaffold(
              appBar: AppBar(title: Text(""),
                  centerTitle: false,
                  automaticallyImplyLeading: true
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Text(""),
              centerTitle: false,
              automaticallyImplyLeading: true,
            ),
            body:  Builder(
              builder: (context) =>
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // MULTA ATLETA
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrangeAccent.withOpacity(0.8),
                                  spreadRadius: 0.5,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("MULTA ATLETA", style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // MOTIVO
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xfff38120).withOpacity(0.8),
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            height: 35,
                            child: Row(
                              children: [
                                Icon(Icons.contact_support, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                    "MOTIVO",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ),
                        // BOX MOTIVO
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                          child: Material(
                            elevation: 10,
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
                                              "$reasonToDisplay",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Stack(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                final reason = await showReasonDialog();
                                                setState(() => reasonToDisplay = reason!);
                                              },
                                              icon: Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 25),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IMPORTO
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 7, 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xfff38120).withOpacity(0.8),
                                      spreadRadius: 0.5,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                height: 35,
                                width: 150,
                                child: Row(
                                  children: [
                                    Icon(Icons.euro_rounded, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                        "IMPORTO",
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextButton(
                                      child: Text(euroText, style: TextStyle(fontSize: 20, color: Colors.black)),
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) => CupertinoActionSheet(
                                            actions: [buildEuroPicker()],
                                            cancelButton: CupertinoActionSheetAction(
                                              child: Text("Chiudi"),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(",", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Flexible(
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextButton(
                                      child: Text(centsText, style: TextStyle(fontSize: 20, color: Colors.black)),
                                      onPressed: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (context) => CupertinoActionSheet(
                                            actions: [buildCentsPicker()],
                                            cancelButton: CupertinoActionSheetAction(
                                              child: Text("Chiudi"),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text("€", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        // DATA
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 7, 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xfff38120).withOpacity(0.8),
                                          spreadRadius: 0.5,
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    height: 35,
                                    width: 150,
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
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 5,
                                child: Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    //width: 210,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "$dateToDisplay",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Stack(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(DateTime.now().year),
                                                    lastDate: DateTime(DateTime.now().year + 5),
                                                  ).then((date) {
                                                    setState(() {
                                                      dateToDisplay = DateFormat("dd/MM/yyy").format(date!);
                                                    });
                                                  });
                                                },
                                                icon: Icon(Icons.event, color: Colors.deepOrangeAccent, size: 25),
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onSurface: Colors.deepOrangeAccent,
                            elevation: 10,
                            padding: EdgeInsets.fromLTRB(45, 17, 45, 17),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Multa",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: () async {
                            if (reasonToDisplay.isEmpty || dateToDisplay.isEmpty) {
                              showErrorSnackBar(context, "Per favore inserire il motivo della multa o la data della violazione.");
                            } else if (reasonToDisplay.isEmpty) {
                              showErrorSnackBar(context, "Per favore inserire il motivo della multa.");
                            } else if (dateToDisplay.isEmpty) {
                              showErrorSnackBar(context, "Per favore inserie la data della violazione.");
                            }else if (euroText == "0" && centsText == "00") {
                              showErrorSnackBar(context, "Per favore inserire un importo non nullo.");
                            } else {
                              Fine fine = await service.finePlayer(reasonToDisplay, int.parse(euroText), int.parse(centsText), dateToDisplay, widget.playerID);
                              setState(() {
                                finesToDisplay.add(fine);
                                reasonToDisplay = "";
                                dateToDisplay = "";
                                euroText = "0";
                                centsText = "00";
                              });
                            }
                          },
                        ),
                        SizedBox(height: 25),
                        // RIASSUNTO MULTE
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrangeAccent.withOpacity(0.8),
                                  spreadRadius: 0.5,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("RIASSUNTO MULTE", style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: finesToDisplay.isEmpty
                              ? SizedBox(height: 100,child: Center(child: Text("Il giocatore non ha multe", style: TextStyle(fontSize: 18))))
                              : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                                itemCount: finesToDisplay.length,
                                itemBuilder: (_, i) => createCard(finesToDisplay, i),
                                separatorBuilder: (context, index) => SizedBox(height: 10)
                          ),
                        ),
                        //SizedBox(height: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50,
                          //color: Colors.yellow,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Text("Debito totale giocatore: ", style: TextStyle(fontSize: 20)),
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
                        ),
                        SizedBox(height: 20),
                        // SALDA MULTE
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onSurface: Colors.deepOrangeAccent,
                            elevation: 10,
                            padding: EdgeInsets.fromLTRB(45, 17, 45, 17),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Salda multe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                          onPressed: () async {
                            showRemoveDialog(widget.playerID);
                          },
                        ),
                        SizedBox(height: 30)
                      ],
                    ),
                  ),
            ),
          );
        }
    );
  }

  Future showRemoveDialog(String playerID) => showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Text(
              "Sicuro di voler saldare il debito totale del giocatore?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.green,
                      ),
                      width: MediaQuery.of(context).size.width/6,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Icon(Icons.done_outline, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await service.clearPlayerFines(playerID);
                      setState(() {
                        finesToDisplay.clear();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.red,
                    ),
                    width: MediaQuery.of(context).size.width/6,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Icon(Icons.highlight_remove, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    ),
  );

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
          Visibility(
            visible: true,
            child: Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () async {
                  showRemoveSingleFineDialog(finesToDisplay[i]);
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

  Future showRemoveSingleFineDialog(Fine fineToRemove) => showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Text(
              "Sicuro di voler saldare la multa del " + fineToRemove.date + " pari a " + fineToRemove.euro.toString() + "," + adjusteCents(fineToRemove.cents) + "€?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 40),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.green,
                      ),
                      width: MediaQuery.of(context).size.width/6,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Icon(Icons.done_outline, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await service.removeFine(fineToRemove.id);
                      setState(() {
                        finesToDisplay.remove(fineToRemove);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.red,
                    ),
                    width: MediaQuery.of(context).size.width/6,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Icon(Icons.highlight_remove, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
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

  Widget buildEuroPicker() => SizedBox(
    height: 300,
    child: CupertinoPicker(
      itemExtent: 70,
      children: euro.map((item) => Center(
        child: Text(
          item,
          style: TextStyle(fontSize: 25),
        ),
      )).toList(),
      onSelectedItemChanged: (index) {
        setState(() {
          indexEuro = index;
          euroText = euro[index];
        });
      },
    ),
  );

  Widget buildCentsPicker() => SizedBox(
    height: 300,
    child: CupertinoPicker(
      itemExtent: 70,
      children: cents.map((item) => Center(
        child: Text(
          item,
          style: TextStyle(fontSize: 25),
        ),
      )).toList(),
      onSelectedItemChanged: (index) {
        setState(() {
          indexCents = index;
          centsText = cents[index];
        });
      },
    ),
  );

  Future<String?> showReasonDialog() => showDialog<String>(
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
                "Motivo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Inserisci la motivazione della multa",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: reasonController,
                  onSaved: (value) {
                    reasonController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Motivo multa",
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
                    Navigator.of(context).pop(reasonController.text);
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