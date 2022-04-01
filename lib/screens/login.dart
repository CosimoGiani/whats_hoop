import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/models/user.dart';
import 'package:whatshoop/screens/athlete_home.dart';
import 'package:whatshoop/screens/main_page.dart';
import 'package:whatshoop/screens/registration.dart';
import 'package:whatshoop/screens/trainer_home.dart';
import 'package:whatshoop/database_service.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final DatabaseService service = new DatabaseService();
  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    // email
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Per favore inserisci la tua mail");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Per favore inserisci una mail valida");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "E-mail",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );

    // password
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Per favore inserisci la tua password");
        }
        if (!regex.hasMatch(value)) {
          return ("Per favore inserisci una password valida");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // bottone login
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepOrangeAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.45,
        onPressed: () {
          login(emailController.text, passwordController.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset("assets/logo.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        children: [
                          Text(
                            "Per rendere più semplice la tua vita cestistica",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          emailField,
                          SizedBox(height: 10),
                          passwordField,
                          SizedBox(height: 30),
                          loginButton,
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Non hai ancora un account? ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                                },
                                child: Text(
                                  "Registrati",
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ),
        ),
    );
  }

  Future login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authentication.signInWithEmailAndPassword(email: email, password: password)
            .then((id) async {
          UserModel userModel = await service.getUserFromID(_authentication.currentUser!.uid);
          if (userModel.type == 1) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TrainerHome()));
          } else if (userModel.teamID!.trim().isNotEmpty) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage(userModel.teamID!, "athlete")));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AthleteHome()));
          }
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            return showErrorSnackBar(context, "Password errata. Per favore riprovare.");
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            return showErrorSnackBar(context, "Nessun utente trovato con questa e-mail");
          default:
            return showErrorSnackBar(context, "Login fallito. Per favore riprovare.");
        }
      }
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_outlined, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade800,
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.fixed,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}


