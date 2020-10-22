import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/customs/platformalertwidget.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class GroupUsername extends StatefulWidget {

  GroupUsername({@required this.usernameClass , @required this.database});
  final UsernameClass usernameClass;
  final Database database;


  @override
  _GroupUsernameState createState() => _GroupUsernameState();
}

class _GroupUsernameState extends State<GroupUsername> {



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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  final FocusNode _userFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  bool _isloading = false;

  String get _username => _usernameController.text;
  String get _name => _nameController.text;



  Future<void> _submit() async {
    setState(() {
      _isloading = true;
    });
    try {
      if (_username.length <= 5) {
        PlatformAlertDialog(
          title: 'Invalid Group username',
          content: "Group username should be of at least 6 characters ",
          defaultActionText: 'ok',
        ).show(context);
      } else if (_username.contains(" ")) {
        PlatformAlertDialog(
          title: 'Invalid group username',
          content: "Group username should not contain spaces",
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
          title: 'Empty group name',
          content: "Name can't be empty ",
          defaultActionText: 'ok',
        ).show(context);
      } else {
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
        if (allGroups.contains(_username) || allNames.contains(_username)){
          PlatformAlertDialog(
            title: 'Operation Failed',
            content: 'This group username have already been used.' ,
            defaultActionText: 'ok',
          ).show(context);
        }
        else {
          final job = Reciever(
              id: _username,
              usernameof: _username,
              nameof: titleCase(_name),
              statusof: 'Lets chat together !',
              isgroup: true,
              timeof: DateTime.now().millisecondsSinceEpoch,
            timejob: DateFormat.jm().format(DateTime.now()),
            deletetime: DateTime.now().millisecondsSinceEpoch,
            dateof: DateFormat("dd/MM/yyyy").format(DateTime.now()),
              storytimeof : 1,
              chatdate : DateFormat("dd/MM/yyyy").format(DateTime.now()),
          );
          await widget.database.setJob1(
              widget.usernameClass.username, job);

          final firestoreInstance = Firestore.instance;
          firestoreInstance
              .collection("allgroups")
              .document(_username)
              .collection('users')
              .document(widget.usernameClass.username)
              .setData({
            'usernameof' : widget.usernameClass.username,
            'nameof' : widget.usernameClass.name,
          }).then((_) {
            print("success!");
          });
          firestoreInstance
              .collection("allgroups")
              .document(_username)
              .setData({
            'usernameof' : _username,
            'nameof' : titleCase(_name),
            'statusof' : 'Lets chat together !',
            'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
          }).then((_) {
            print("success!");
          });

          Map<String, dynamic> chatMessageMap = {
            "sendBy": widget.usernameClass.username,
            "message": '',
            'time': DateTime
                .now()
                .millisecondsSinceEpoch,
            'isimage': false,
            "sendername" : widget.usernameClass.name,
            'createdtime' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
            'creatednow' : true,
            'isgroup' : true,
            'msgtime' : DateTime.now().millisecondsSinceEpoch ,
            'groupusername' : _username
          };

          final String chatroomid3 = '${_username}';

          widget.database.addMessage(chatroomid3, chatMessageMap);

          Navigator.pop(context);

        }
      }
    } finally {
      setState(() {
        _btnController.reset();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new group'),
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
                  backgroundImage: AssetImage('images/group_icon.png'),
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
                    labelText: 'Group Username',
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
                    labelText: 'Group Name'
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
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.indigo,
                  controller: _btnController,
                  onPressed:  _submit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
