import 'dart:async';
import 'package:chattingapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'landing.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration( seconds: 3);
    return Timer(duration , route);
  }

  route(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => Landing(auth: Auth()),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black ,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 200),
                    Image.asset('images/chatpad.jpg' , width: 230,height: 230,),
                  ],
                ),
                SizedBox(height: 250,),
                Text('ChatPad ' , style:  TextStyle(fontSize: 24 , fontWeight: FontWeight.w600 , letterSpacing: 2,color: Colors.white70),),
              ],
            ),
          ),
        ),
      )
    );
  }
}

