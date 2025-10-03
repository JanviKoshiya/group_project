import 'dart:async';

import 'package:flutter/material.dart';

import 'main.dart';

class splash_page extends StatefulWidget {
  const splash_page({super.key});

  @override
  State<splash_page> createState() => _splash_pageState();
}

class _splash_pageState extends State<splash_page> {

  @override
  void initState() {
    super.initState();
    Timer(Duration (seconds: 2) , (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset('images/scoing_app_logo.png')
        ),
      ),
 
    );
  }
}
