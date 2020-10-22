import 'package:chattingapp/signin_and_enterdetails/homelandingpage.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/database.dart';
import 'package:chattingapp/signin_and_enterdetails/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  Landing({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: auth.onAuthStateChange,
        builder: (context , snapshot)
        {
          if (snapshot.connectionState==ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage(
                auth: auth,
              );
            }
            return Provider<Database>(
              builder: (_) => FirestoreDatabase(uid: user.uid),
              child: HomeLandingPage(
                auth: auth,
                ),
            );
          } else{
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.black87,
            );
          }
        });
  }
}
