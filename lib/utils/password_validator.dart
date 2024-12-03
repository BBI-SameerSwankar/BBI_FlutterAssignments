import 'package:flutter/material.dart';

class PasswordValidator extends StatefulWidget {
  String? password = "";
  PasswordValidator({this.password});

  @override
  State<PasswordValidator> createState() => _PasswordValidatorState();
}

class _PasswordValidatorState extends State<PasswordValidator> {


  
  Widget isSpecialCharacterPresent() {
    bool hasSpecialChar =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(widget.password!);
    if (hasSpecialChar) {
      return const Text(
        "Password contains a special character",
        style: TextStyle(color: Colors.green),
      );
    }
    return Container();
  }

  // Check if the password length is valid (at least 8 characters)
  Widget isLengthValid() {
    bool isValidLength = widget.password!.length >= 8;

    if(isValidLength)
    {
      return const Text(
        "Password length is above 8",
        style: TextStyle(color: Colors.green),
      );
    }
    return Container();
  }

  // Check if the password contains numbers
  Widget isNumbersPresent() {
    bool hasNumbers = RegExp(r'\d').hasMatch(widget.password!);
    if(hasNumbers)
    {
      return const Text(
        "Password contains atleast one number",
        style: TextStyle(color: Colors.green),
      );
    }
    return Container();

  }

  // Check if the password contains a capital letter
  Widget isCapitalLetterPresent() {
    bool hasUpperCase = RegExp(r'[A-Z]').hasMatch(widget.password!);
    if(hasUpperCase)
    {
      return const Text("Password contains at least one capital letter", 
       style: TextStyle(color: Colors.green),);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        isSpecialCharacterPresent(),
        isLengthValid(),
        isNumbersPresent(),
        isCapitalLetterPresent(),

        ]
      ),
    );
  }
}
