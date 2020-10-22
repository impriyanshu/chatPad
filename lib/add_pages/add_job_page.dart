import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/customs/platformalertwidget.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddJobPage extends StatefulWidget {

  const AddJobPage({Key key, @required this.database, this.usernameClass}) : super(key: key);
  final Database database;
  final UsernameClass usernameClass ;


  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {


  final TextEditingController _usernameController = TextEditingController();

  bool _validateAndSaveForm() {
    final form = _fromKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  final _fromKey = GlobalKey<FormState>();
  String _username;


  @override
  Widget build(BuildContext context) {

    Future<void> _submit() async {

      if (_validateAndSaveForm()) {
        try {

          final jobs = await widget.database
              .usernaStream()
              .first;
          final collections = await widget.database
              .jobsStream(widget.usernameClass.username)
              .first;
          final allNames = jobs.map((job) => job.username).toList();
          final allCollections = collections.map((job) => job.usernameof).toList();
          final firestoreInstance = Firestore.instance;
          var firebaseUser = await FirebaseAuth.instance.currentUser();
          firestoreInstance.collection("users").document(firebaseUser.uid).get().then((value) async {
            if(_username == widget.usernameClass.username) {
              PlatformAlertDialog(
                title: 'Operation Failed',
                content: "User can't use his/her username",
                defaultActionText: 'ok',
              ).show(context);
              _usernameController.clear();
            }

            else if (allNames.contains(_username)) {
              if(allCollections.contains(_username)){
                PlatformAlertDialog(
                  title: 'Operation Failed',
                  content: 'User with this username already exists on your chatbox',
                  defaultActionText: 'ok',
                ).show(context);
                _usernameController.clear();
              }
              else {

                String url;
                firestoreInstance.collection ( 'allusers' ).document (
                    widget.usernameClass.username ).get ( ).then ( ( value ) {
                  url = value.data['url'];
                });

                firestoreInstance.collection("allusers").document(
                    _username).get().then((value) async {
                  final job1 = Reciever(
                      id: _username,
                      timejob: DateFormat.jm().format(DateTime.now()),
                      usernameof: _username,
                      urlof: value.data['urlof'],
                      statusof: 'Always on duty!',
                      nameof: value.data['nameof'],
                      dateof : DateFormat("dd/MM/yyyy").format(DateTime.now()),
                      timeof: DateTime.now().millisecondsSinceEpoch);
                  await widget.database.setJob1(
                      widget.usernameClass.username, job1);
                });
                final job2 = Reciever(
                    id: widget.usernameClass.username,
                    urlof: url,
                    usernameof: widget.usernameClass.username,
                    dateof : DateFormat("dd/MM/yyyy").format(DateTime.now()),
                    statusof: widget.usernameClass.status,
                    timejob: DateFormat.jm().format(DateTime.now()),
                    nameof: widget.usernameClass.name,
                    timeof:DateTime.now().millisecondsSinceEpoch);
                await widget.database.setJob2(_username, job2);


                PlatformAlertDialog(
                  title: 'Operation Successful',
                  content: "User has been added to your chatbox",
                  defaultActionText: 'ok',
                ).show(context);
                _usernameController.clear();


                await firestoreInstance.collection("chatlink/${value.data["username"]}_${_username}/chat").add(
                    {
                    });

                await firestoreInstance.collection("chatlink/${_username}_${value.data["username"]}/chat").add(
                    {
                    });



              }
            }
            else {
              PlatformAlertDialog(
                title: 'Operation Failed',
                content: 'No user with username '  + _username + " .",
                defaultActionText: 'ok',
              ).show(context);
              _usernameController.clear();
            } });
        } on PlatformException catch (e) {
          PlatformAlertDialog(
            title: 'Operation Failed',
            content: 'Cant allow',
            defaultActionText: 'ok',
          ).show(context);

        }

      }
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: Text('Enter username'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed:  _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _fromKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        controller: _usernameController,
        initialValue: null,
        decoration: InputDecoration(
          labelText: 'Username',
        ),
        validator: (value) => value.isNotEmpty ? null : "Value can't be empty",
        onSaved: (value) => _username = value,
      ),
    ];
  }

}