
import 'package:chattingapp/services/auth.dart';
import 'package:flutter/material.dart';

import 'email_sign_in_form.dart';

class  EmailSignInPage extends StatelessWidget {
  EmailSignInPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text('Sign In',),
    centerTitle: true,
    elevation: 2.0,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: EmailSignInForm(auth: auth),
        ),
      ),
    ),
    backgroundColor: Colors.grey[200],
    );
  }
}