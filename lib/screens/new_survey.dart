import 'package:flutter/material.dart';
import 'package:whatshoop/models/survey.dart';

import 'package:whatshoop/database_service.dart';

class NewSurvey extends StatefulWidget {

  String teamID;
  NewSurvey(this.teamID);

  @override
  _NewSurveyState createState() => _NewSurveyState();

}

class _NewSurveyState extends State<NewSurvey> {

  String titleToDisplay = "";
  String questionToDisplay = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController questionController = new TextEditingController();
  final TextEditingController optionController = new TextEditingController();
  List<String> options = [];
  final DatabaseService service = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Nuovo sondaggio"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 25),
                  child: Column(
                    children: [
                      // TITOLO
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrangeAccent,
                        ),
                        height: 35,
                        child: Row(
                          children: [
                            Icon(Icons.text_fields, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                                "TITOLO",
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
                                          "$titleToDisplay",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    //padding: EdgeInsets.only(top: 10),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 13.5,
                                          top: 13,
                                          child: Icon(Icons.edit, color: Colors.black.withAlpha(150), size: 25),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final title = await showTitleDialog();
                                            setState(() => titleToDisplay = title!);
                                          },
                                          icon: Icon(Icons.edit),
                                          color: Colors.deepOrangeAccent,
                                          iconSize: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // DOMANDA
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrangeAccent,
                        ),
                        height: 35,
                        child: Row(
                          children: [
                            Icon(Icons.question_answer, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                                "DOMANDA",
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
                                          "$questionToDisplay",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 13.5,
                                          top: 13,
                                          child: Icon(Icons.edit, color: Colors.black.withAlpha(150), size: 25),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final question = await showQuestionDialog();
                                            setState(() => questionToDisplay = question!);
                                          },
                                          icon: Icon(Icons.edit),
                                          color: Colors.deepOrangeAccent,
                                          iconSize: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // OPZIONI
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrangeAccent,
                        ),
                        height: 35,
                        child: Row(
                          children: [
                            Icon(Icons.format_list_bulleted, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                                "OPZIONI",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: options.isEmpty
                            ? null
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (_, i) => createCard(options, i),
                                separatorBuilder: (context, index) => SizedBox(height: 5),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 100,
                            child: IconButton(
                              onPressed: () async {
                                final optionToAdd = await showOptionDialog();
                                setState(() {
                                  options.add(optionToAdd!);
                                });
                              },
                              icon: Icon(Icons.add, color: Colors.deepOrangeAccent),
                            ),
                          ),
                        ),
                      ),
                      // BOTTONE CREA
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
                          "Crea",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () async {
                          if(titleToDisplay.isEmpty || questionToDisplay.isEmpty || options.length == 0) {
                            showErrorSnackBar(context, "Per favore inserire tutti i campi necessari.");
                          } else if (options.length < 2) {
                            showErrorSnackBar(context, "Le opzioni del sondaggio devono essere almeno 2.");
                          } else {
                            //Activity activity = await service.addNewActivity(widget.teamID, value!, dateToDisplay, timeToDisplay, placeController, notesController);
                            await service.addNewSurvey(widget.teamID, titleToDisplay, questionToDisplay, options);
                            Navigator.of(context).pop();
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

  Future<String?> showOptionDialog() => showDialog<String>(
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
                "Opzione",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Inserisci una opzione del sondaggio",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: optionController,
                  onSaved: (value) {
                    optionController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Scrivi l'opzione qua",
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
                    if (optionController.text.trim().isEmpty) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop(optionController.text);
                    }
                  },
                  child: Text(
                    "Aggiungi",
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

  Future<String?> showTitleDialog() => showDialog<String>(
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
                "Titolo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Inserisci un titolo per il sondaggio",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: titleController,
                  onSaved: (value) {
                    titleController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Titolo sondaggio",
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
                    Navigator.of(context).pop(titleController.text);
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

  Future<String?> showQuestionDialog() => showDialog<String>(
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
                "Domanda",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Inserisci il testo della domanda che vuoi fare",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 7, 15, 10),
                child: TextFormField(
                  controller: questionController,
                  onSaved: (value) {
                    questionController.text = value!;
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Cosa vuoi chiedere?",
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
                    Navigator.of(context).pop(questionController.text);
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

  createCard(List<String> optionsToDisplay, int i) => Card(
    shadowColor: Colors.grey,
    elevation: 7,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.white,
    child: Container(
        padding: EdgeInsets.fromLTRB(25, 10, 10, 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(optionsToDisplay[i], style: TextStyle(fontSize: 20)),
              ],
            ),
            Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    setState(() => options.remove(optionsToDisplay[i]));
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.cancel_rounded, color: Colors.deepOrange),
                  ),
                ),
              ),
          ],
        ),
      ),
  );

}