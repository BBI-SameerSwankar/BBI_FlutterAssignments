import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {


  int counter;
  Homepage({
      this.counter = 0
   });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          

          Text("Counter",style: TextStyle( fontSize: 30),),
          SizedBox(height: 30,),
          Text("${widget.counter}", style: TextStyle(fontSize: 25),),
          Container(height: 1000,)
          
        ],
      ),
    );
  }
}