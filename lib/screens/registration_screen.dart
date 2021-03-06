import 'package:flutter/material.dart';
import 'package:flash_chat/components/PaddingWithButton.dart';
import 'package:flash_chat/components/DecoratedTextField.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String userEmail;
  String password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'LOGO',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userEmail = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              PaddingWithButton(
                buttonText: 'Register',
                buttonColor: Colors.blueAccent,
                onPress: () async {
                  //Implement registration functionality.
                  setState(() {
                    _saving = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: userEmail, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } on Exception catch (e) {
                    // TODO
                    print(e);
                  }
                  setState(() {
                    _saving = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
