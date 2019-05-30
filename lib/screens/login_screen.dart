import 'package:flutter/material.dart';
import 'package:flash_chat/components/PaddingWithButton.dart';
import 'package:flash_chat/components/DecoratedTextField.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'LOGO',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            DecoratedTextField(
              hintText: 'Enter your email',
              onChangedCallback: (value) {},
            ),
            SizedBox(
              height: 8.0,
            ),
            DecoratedTextField(
              hintText: 'Enter your password.',
              borderColor: Colors.lightBlueAccent,
              onChangedCallback: (value) {},
            ),
            SizedBox(
              height: 24.0,
            ),
            PaddingWithButton(
              buttonColor: Colors.lightBlueAccent,
              buttonText: 'Log In',
              onPress: () {
                // Implement login functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
