import 'package:flutter/material.dart';

typedef OnChangedCallback = void Function(String);

class DecoratedTextField extends StatelessWidget {
  final Color borderColor;
  final String hintText;
  final OnChangedCallback onChangedCallback;

  DecoratedTextField({this.borderColor, this.hintText, this.onChangedCallback});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        //Do something with the user input.
        onChangedCallback(value);
      },
      decoration: InputDecoration(
        hintText: hintText ?? '',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: borderColor ?? Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: borderColor ?? Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
