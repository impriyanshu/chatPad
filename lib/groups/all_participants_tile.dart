
import 'dart:async';

import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllParticipans_tile extends StatefulWidget {

  AllParticipans_tile({@required this.job, @required this.usernameClass, @required this.name , @required this.database, this.controller});
  final Reciever job;
  final UsernameClass usernameClass;
  final Reciever name;
  final Database database;
  final TextEditingController controller;

  @override
  _AllParticipans_tileState createState() => _AllParticipans_tileState();
}

class _AllParticipans_tileState extends State<AllParticipans_tile> {

  String url;
  bool group;
  bool _loading = false;

  final firestoreInstance = Firestore.instance;

  void urll() {
    firestoreInstance.collection('allusers').document(widget.job.usernameof).get().then((value){
      url = value.data['urlof'];
    });
  }

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(milliseconds: 1100), _login);
    });
  }

  Timer timer;
  String c = "";

  Future _login() async{
    setState((){
      _loading = false;
    });
  }

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
    return  widget.job.usernameof.toString().contains(c) || widget.job.nameof.toString().contains(c) ? Container(
      color: Colors.grey[300],
      height: 74,
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
                Icon(Icons.person,color: Colors.grey[800],size: 22,),
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
      ),
    ) : SizedBox(height: 0,);
  }

}
