import 'dart:async';

import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddMembers_tile extends StatefulWidget {
  AddMembers_tile({@required this.job, @required this.usernameClass, @required this.name , @required this.database, this.controller});
  final Reciever job;
  final UsernameClass usernameClass;
  final Reciever name;
  final Database database;
  final TextEditingController controller;

  @override
  _AddMembers_tileState createState() => _AddMembers_tileState();
}

class _AddMembers_tileState extends State<AddMembers_tile> {


  String url;
  bool group;
  bool _loading = false;
  bool _isloading = false;

  final firestoreInstance = Firestore.instance;

  void urll() {
    firestoreInstance.collection('allusers').document(widget.job.usernameof).get().then((value){
      url = value.data['urlof'];
      group = value.data['isgroup'];
    });
  }

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(milliseconds: 1100), _login);
    });
  }


  Future _login() async{
    setState((){
      _loading = false;
    });
  }

  Timer timer;
  String c = "";

  @override
  void initState() {
    urll();
    _onLoading();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
    super.initState();
  }


  checkForNewSharedLists(){
    setState(() {
      c = widget.controller.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    return widget.job.isgroup == true ? Container(height: 0,width: 0,) : widget.job.usernameof.toString().contains(c) || widget.job.nameof.toString().contains(c) ?
    Container(
      height: 74,
      color: Colors.grey[300],
      child: ListTile(
        leading: SizedBox(
          child: CircleAvatar(
            backgroundImage : _loading == true ?  AssetImage('') : url != null ? NetworkImage('${url}') : group == true ? AssetImage('images/group_icon.png') : AssetImage('images/${ widget.job.nameof.toString()[0]}.png') , radius: 24,),
          height: 46,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(widget.job.nameof.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 7,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.person , color: Colors.grey[800],size: 22,),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    widget.job.usernameof.toString(),
                    style: GoogleFonts.aBeeZee(
                      textStyle : TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ],

        ),
        trailing: CircleAvatar(child: FlatButton(child : _isloading == true ?  CircularProgressIndicator()  :  Icon(Icons.add , size: 28,) , onPressed : ()=> addGroup(context) ) ,backgroundColor: Colors.grey[300],radius: 36,),
      ),
    ) : SizedBox(height: 0,);
  }

  Future<void> addGroup(BuildContext context) async {
    setState(() {
      _isloading = true;
    });

    final groups = await widget.database.allGroupInUserStream(widget.name.usernameof).first;
    final allgroups = groups.map((job) => job.usernameof ).toList();

    String lastchatdate;


    if (allgroups.contains(widget.job.usernameof)){
      print(allgroups);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("User already exists in this group."),
        duration: Duration(seconds: 3),
      ));
    }
    else {

      firestoreInstance
          .collection ("connect")
          .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
        lastchatdate = value.data['chatdate'];
      });

      firestoreInstance
          .collection("allgroups")
          .document(widget.name.usernameof)
          .collection('users')
          .document(widget.job.usernameof)
          .setData({
        'usernameof': widget.job.usernameof,
        'nameof': widget.job.nameof,
      }).then((_) {
        print(widget.job.usernameof);
      });

      final job = Reciever(
          id: widget.name.usernameof,
          usernameof: widget.name.usernameof,
          nameof: widget.name.nameof,
          isgroup: true,
          timeof: DateTime.now().millisecondsSinceEpoch,
          timejob : DateFormat.jm().format(DateTime.now()),
          deletetime: DateTime.now().millisecondsSinceEpoch,
          dateof : DateFormat("dd/MM/yyyy").format(DateTime.now()),
          storytimeof : 1,
          chatdate: lastchatdate,
      );
      await widget.database.setJob1(
          widget.job.usernameof, job);

      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.usernameClass.username,
        "message" : "",
        "isgroup" : true,
        "isimage" : false,
        "sendTo" : widget.job.usernameof,
        "sendername" : widget.usernameClass.name,
        'lastsender' : 'no',
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        'isimage': true,
        'sending' : true,
        'msgtime' : DateTime.now().millisecondsSinceEpoch
      };

      widget.database.addMessage(widget.name.usernameof, chatMessageMap);



      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Added to group."),duration: Duration(seconds: 3),
      ));
    }

  setState(() {
    _isloading=false;
  });
  }
}

