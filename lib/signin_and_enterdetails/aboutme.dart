import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Need a help ? Contact us' ,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20
            ),),
            SizedBox(height: 20,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                FlatButton(
                  child: CircleAvatar(
                    child: Image.asset('images/google.jpg'),
                    radius: 24,
                  ),
                  onPressed: google,
                ),
                FlatButton(
                  child: CircleAvatar(
                    child: Image.asset('images/linked.png'),
                    radius: 22,
                  ),
                  onPressed: linked,
                ),
                FlatButton(
                  child: CircleAvatar(
                    child: Image.asset('images/instagram.png'),
                    radius: 22,
                  ),
                  onPressed: insta,
                ),
              ],
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> google() async {

    final Email email = Email (
      recipients: ['chatpad14@gmail.com'] ,
    );

    await FlutterEmailSender.send ( email );
  }

  Future<void> linked() async {
    const url = 'https://www.linkedin.com/in/priyanshu--agarwal/';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  Future<void> insta() async {
    const url = 'https://www.instagram.com/_agarwal_.priyanshu/';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
}
