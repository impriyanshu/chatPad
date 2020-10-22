
import 'dart:io';
import 'package:chattingapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

enum EmailSignInFormType { signIn, register}


class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}


class _EmailSignInFormState extends State<EmailSignInForm> {

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();


  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose(){
    _passwordController.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
  }


  _notsubmit(){
    _btnController.reset();
  }


  void _submit() async {

    setState(() {
        _submitted = true;
        _loading = true;
      });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailPassword(
            _email, _password);
      }
      else {
        await widget.auth.createUserWithEmailPassword(
            _email, _password);
      }
      Navigator.pop(context);

      setState(() {
        _btnController.reset();

      });


    } on PlatformException catch(e){
      if(Platform.isIOS){
        showDialog(context: context,
            builder:  (context){
              return CupertinoAlertDialog(
                title:  Text('Sign In failed'),
                content: Text(e.message),
                actions: [
                  FlatButton (
                    child: Text('Ok'),
                    onPressed: () =>  Navigator.pop(context),
                  )
                ],
              );
            });
      }
      else {
        showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Sign In failed'),
                content: Text(e.message),
                actions: [
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              );
            });
      }
      setState(() {
        _btnController.reset();

      });


    }finally{
      setState(() {
        _loading = false;
        _btnController.reset();

      });
    }

  }

  void _emailEditing(){
    final correctionScopeEmail = _email.isNotEmpty ? _passFocus : _emailFocus  ;
    FocusScope.of(context).requestFocus(correctionScopeEmail);
  }




    @override
    Widget build(BuildContext context) {
      final pText = _formType == EmailSignInFormType.signIn ?
      'Sign in' : 'Create an account';
      final sText = _formType == EmailSignInFormType.signIn ?
      'Need an account? Register' : 'Have an account ? Sign in';

      void _toogle() {
        setState(() {
          _submitted=false;
        });
        setState(() {
          _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
        });
        _passwordController.clear();
        _emailController.clear();
      }

      bool submitEnable = _email.isNotEmpty && _password.isNotEmpty && !_loading;

      _updateSubmitButton(){
        setState(() {

        });
      }


      bool emailValid =  !_email.isNotEmpty && _submitted;
      bool passwordValid = !_password.isNotEmpty && _submitted;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'test@gmail.com',
                errorText : emailValid ?  "Email can't be empty" : null ,
              ),

              onChanged: (email) => _updateSubmitButton(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: _loading == false,
              focusNode: _emailFocus,
              onEditingComplete: _emailEditing,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                  errorText : passwordValid ? "Email can't be empty" : null,
              ),
              obscureText: true,
              focusNode: _passFocus,
              enabled: _loading == false,
              onChanged: (password) => _updateSubmitButton(),
              textInputAction: TextInputAction.done,
              onEditingComplete : _submit,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: 400,
              child: RoundedLoadingButton(
                controller: _btnController,
                child: Text(
                  pText,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),

                ),
                color: submitEnable ?  Colors.indigo : Colors.grey,
                onPressed :  submitEnable ? _submit : _notsubmit,

              ),

            ),
            FlatButton(
              child: Text(
                sText,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: !_loading ? _toogle : null ,

            )
          ],
        ),
      );
    }
}
