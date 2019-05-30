import 'package:flutter/material.dart';
import 'package:flash_chat/components/PaddingWithButton.dart';
import 'package:flash_chat/components/DecoratedTextField.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              onChangedCallback: (value) {
                print(value);
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            DecoratedTextField(
              hintText: 'Enter your password',
              onChangedCallback: (value) {},
            ),
            SizedBox(
              height: 24.0,
            ),
            PaddingWithButton(
              buttonText: 'Register',
              buttonColor: Colors.blueAccent,
              onPress: () {
                //Implement registration functionality.
              },
            )
          ],
        ),
      ),
    );
  }
}
