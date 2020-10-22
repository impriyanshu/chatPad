import 'dart:async';
import 'dart:math';
import 'package:chattingapp/contacts/homepage.dart';
import 'package:chattingapp/customs/platformalertwidget.dart';
import 'package:chattingapp/services/auth.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../Modles/reciever.dart';
import '../Modles/username.dart';

class EnterUserName extends StatefulWidget {
  EnterUserName(
      {Key key,
      @required this.database,
      @required this.usernameClass,
      @required this.auth});
  final Database database;
  final UsernameClass usernameClass;
  final AuthBase auth;

  static Future<void> show(BuildContext context,
      {Database database, UsernameClass usernameClass, AuthBase auth, RoundedLoadingButtonController controller}) async {
    final firestoreInstance = Firestore.instance;
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    firestoreInstance
        .collection("users")
        .document(firebaseUser.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        print(value.data["username"]);
        print(value.data['status']);

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(
                usernameClass: UsernameClass(
                    id: value.data["id"],
                    username: value.data["username"],
                    status: value.data["status"],
                    name: value.data["name"]),
                database: database),
            fullscreenDialog: true,
          ),
        );
        controller.reset();
      } else {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EnterUserName(
              database: database,
              usernameClass: usernameClass,
              auth: auth,
            ),
            fullscreenDialog: true,
          ),
        );
        controller.reset();
      }
    });
  }

  @override
  _EnterUserNameState createState() => _EnterUserNameState();
}

class _EnterUserNameState extends State<EnterUserName> with SingleTickerProviderStateMixin{

  String titleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  bool _isloading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String get _username => _usernameController.text;
  String get _name => _nameController.text;

  final FocusNode _userFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    bool passwordValid =
        !_username.isNotEmpty && _submitted && !_name.isNotEmpty;


    Future<void> _submit() async {

      try {

        print(_name.codeUnitAt(0));
        if (_username.length <= 5) {
          PlatformAlertDialog(
            title: 'Invalid Username',
            content: "Username should be of at least 6 characters ",
            defaultActionText: 'ok',
          ).show(context);
        } else if (_username.contains(" ")) {
          PlatformAlertDialog(
            title: 'Invalid Username',
            content: "Username should not contain white spaces",
            defaultActionText: 'ok',
          ).show(context);
        }
        else if(!(_name.codeUnitAt(0) >= 65 && _name.codeUnitAt(0) <= 90) && !(_name.codeUnitAt(0) >= 97 && _name.codeUnitAt(0) <= 122)){
          PlatformAlertDialog(
            title: 'Invalid Name',
            content: "Name should start with an alphabet",
            defaultActionText: 'ok',
          ).show(context);
        }
        else if (_name.length == 0) {
          PlatformAlertDialog(
            title: 'Empty name',
            content: "Name can't be empty ",
            defaultActionText: 'ok',
          ).show(context);
        }
        else if(_name[0]==" " ){
          PlatformAlertDialog(
            title: 'Invalid name',
            content: "First letter should not  be white space",
            defaultActionText: 'ok',
          ).show(context);
        }
        else {
          final usernameclasss = await widget.database.allJobsStream().first;
          final allNames = usernameclasss
              .map((job) => job.usernameof)
              .toList();
          final groups = await widget.database.allGroupsStream().first;
          final allGroups = groups
              .map((job) => job.usernameof)
              .toList();

          if (widget.usernameClass != null) {
            allNames.remove(widget.usernameClass.username);
          }
          if (allNames.contains(_username) || allGroups.contains(_username) ) {
            PlatformAlertDialog(
              title: 'Operation Failed',
              content: 'This username have already been registered ' ,
              defaultActionText: 'ok',
            ).show(context);
          } else {

            var firebaseUser = await FirebaseAuth.instance.currentUser();
            final id = documentIdFromCurrentDate();
            final usernameclass = UsernameClass(
                id: id,
                username: _username,
                status: "Always on duty!",
                name: titleCase(_name));
            await widget.database.setUserna(usernameclass);

            final job = Reciever(
                id: _username,
                usernameof: _username,
                statusof: 'Always on duty!',
                nameof: titleCase(_name),
                emailof: null,
                storytimecheck: 1,
                storytimeof: 1
            );
            await widget.database.setJoball(job);

            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  usernameClass: usernameclass,
                  database: widget.database,
                ),
                fullscreenDialog: true,
              ),
            );
          }
        }
      }
      finally {
        setState(() {
          _btnController.reset();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text('Enter user name'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/username-logo1.webp'),
                  radius: 100,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Username'
                  ),

                  maxLength: 25,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Full Name'
                  ),
                  focusNode: _nameFocus,
                  maxLength: 30,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                width: 180,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.indigo,
                  onPressed: _submit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
