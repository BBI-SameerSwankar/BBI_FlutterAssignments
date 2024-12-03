import 'package:flutter/material.dart';

class EmailValidtor extends StatefulWidget {
  String? email ="";
   EmailValidtor({this.email});

  @override
  State<EmailValidtor> createState() => _EmailValidtorState();
}


class _EmailValidtorState extends State<EmailValidtor> {

Widget isSpecialCharacterPresent()
{
  if(widget.email!.contains('@'))
  {
  return Text("Email contains the symbol @",style: TextStyle(color: Colors.green),);
  }
  return Container();
}


Widget isDomainPresent()
{
   if (widget.email != null &&
        widget.email!.contains('@') && // Ensure @ is present
        widget.email!.split('@').length > 1 && // Split email and check for domain
        widget.email!.split('@')[1].contains('.')) { // Check if domain contains a period (.)
      return Text(
        "Email contains a valid domain",
        style: TextStyle(color: Colors.green),
      );
    }

  return Container();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
    
          isSpecialCharacterPresent(),
          isDomainPresent()
      
      
        ],
      ),
    );
  }
}