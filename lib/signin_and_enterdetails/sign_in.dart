import 'package:chattingapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import '../customs/custombutton.dart';
import 'email_sign_in_page.dart';
class SignInPage extends StatefulWidget {

  SignInPage({@required this.auth});
  final AuthBase auth;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _isLoading = false;

  Future <void> _signInAnonymously() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future <void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future <void> _signInWithFacebook() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithEmail(BuildContext context){
    Route route = MaterialPageRoute( builder: (context) => EmailSignInPage(auth: widget.auth));
    Navigator.push(context,route);
  }


  @override
  Widget build(BuildContext context) {

    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.lightGreenAccent))
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text('ChatPad' , style: TextStyle(letterSpacing: 2),),
        centerTitle: true,
        backgroundColor: Colors.indigo[700],
        elevation: 2.0,
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
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [animation["color1"], animation["color2"]])),
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _builtMethod(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _builtMethod(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            circularLoading(),
            SizedBox(height: 30),
            CustomButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset('images/google-logo.png'),
                  Text('Sign In Using Google'),
                  SizedBox(
                    width: 18,
                  )
                ],
              ),
              color: Colors.white,
              onPressed: _isLoading ? null : _signInWithGoogle,
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            CustomButton(
              child: Text('Sign In Using Email' , style: TextStyle(color: Colors.white),),
              color: Colors.teal,
              onPressed : () => _isLoading ? null : _signInWithEmail(context) ,
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            CustomButton(
              child: Text('Sign In As Guest'),
              color: Colors.lime,
              onPressed: _isLoading ? null : _signInAnonymously,
            ),
          ],
        ),
      ),
    );
  }
  Widget circularLoading(){
    if(_isLoading){
      return Center(
          child: CircularProgressIndicator()
      );
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        letterSpacing: 1,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
