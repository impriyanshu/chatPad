import 'dart:io';
import 'package:chattingapp/signin_and_enterdetails/enter_username.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:simple_animations/simple_animations.dart';
import 'feedbackform.dart';

class HomeLandingPage extends StatefulWidget {

  HomeLandingPage({@required this.auth});
  final AuthBase auth;

  @override
  _HomeLandingPageState createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _revController = new RoundedLoadingButtonController();


  bool _isloading = false;



  Future <void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {

    Future <void> _isSubmit(){
      Navigator.pop(context);
      _signOut();
    }

  Future<void> _alertDialogue() async {
      await showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign out'),
              content: Text('Are you sure that you want to sign out ? '),
              actions: [
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text('Sign Out'),
                      onPressed: () => _isSubmit(),
                    ),

                  ],
                )
              ],
            );
          });
    }


    Future<void> _coupertinoAlert() async {

      await showDialog(context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Sign out'),
              content: Text('Are you sure that you want to sign out ? '),
              actions: [
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                FlatButton(
                  child: Text('Sign Out'),
                  onPressed: () => _isSubmit(),
                    ),
                  ],
                ),
              ],
            );
          });
    }


    Future<void> _submit() async {
      setState(() {
        _isloading = true;
      });
      try {
        EnterUserName.show(
            context, auth: widget.auth, database: Provider.of<Database>(context) , controller : _btnController);
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }

    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Colors.green[700], end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.lightGreenAccent))
    ]);

return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    actions: <Widget>[
      FlatButton(
        child: Text('Logout',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),
        ),

        onPressed: Platform.isIOS ? _coupertinoAlert : _alertDialogue,
      ),
    ],
  ),
  body: Builder(
    builder: (context) => Stack(
      fit: StackFit.expand,
      children: <Widget>[
    ControlledAnimation(
    playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/bg_img.jpg')
              )
          ),
        );
      },
    ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width : 250,
                    child: RoundedLoadingButton(
                      controller: _btnController,
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                      color: Colors.indigo,
                      onPressed : _isloading  ? null : _submit,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 35,),
              Column(
                children: <Widget>[
                  Container(
                    width: 140,
                    child: RoundedLoadingButton(
                      controller: _revController,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Reviews',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.feedback , color: Colors.indigo[100],),
                          )
                        ],
                      ),

                      color: Colors.red,
                      onPressed : (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => FeedBackForm(),
                              fullscreenDialog: true
                          ),
                        );
                        _revController.reset();
                      },
                    ),

                  ),

                ],
              )
            ],
          ),
        ),
      ],
    ),
  ),
);


  }


}
