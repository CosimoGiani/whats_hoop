import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatshoop/screens/trainer_home.dart';

class RegistrationScreen extends StatefulWidget {

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // TODO fortificare i controlli sugli input

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController = new TextEditingController();
  int selectedValue = 0;
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
      ),
    );

    // nome
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Per favore inserisci il tuo nome");
        }
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Nome",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // cognome
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        //RegExp regex = new RegExp(r'^.{1,}$');
        if (value!.isEmpty) {
          return ("Per favore inserisci il tuo cognome");
        }
        return null;
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Cognome",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // password
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Per favore inserisci una password");
        }
        if (!regex.hasMatch(value)) {
          return ("Per favore inserisci una password valida");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // ripeti password
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return "Le password non corrispondono";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Ripeti password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // bottone registrati
    final signupButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepOrangeAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.45,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: Text(
          "Registrati",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "REGISTRATI",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    emailField,
                    SizedBox(height: 10),
                    firstNameField,
                    SizedBox(height: 10),
                    lastNameField,
                    SizedBox(height: 10),
                    passwordField,
                    SizedBox(height: 10),
                    confirmPasswordField,
                    //SizedBox(height: 1),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: Radio(
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (value) => setState(() => selectedValue = 1) ,
                          ),
                        ),
                        //SizedBox(width: 5),
                        Text(
                          "Allenatore",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 95),
                        Transform.scale(
                          scale: 1.3,
                          child: Radio(
                            value: 2,
                            groupValue: selectedValue,
                            onChanged: (value) => setState(() => selectedValue = 2),
                          ),
                        ),
                        //SizedBox(width: 5),
                        Text(
                          "Atleta",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    signupButton,
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _authentication.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {createFirebaseUser()});
    }
  }

  Future createFirebaseUser() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _authentication.currentUser;
    await firebaseFirestore
        .collection("users")
        .doc(user!.uid)
        .set({
          "id": user.uid,
          "email": user.email,
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "type": selectedValue
        });
    if (selectedValue == 1) {
      Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => TrainerHome()), (route) => false);
    }
    if (selectedValue == 2) {
      // TODO fare andare sulla pagina dell'atlelta se ci si registra come giocatori
    }
  }

}
