import 'dart:async';

import'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AllJobsListTile extends StatefulWidget {
  AllJobsListTile({Key key , @required this.job , @required this.onTap, @required this.usernameClass, @required this.database,  this.controller}): super (key : key);
  final Reciever job ;
  final VoidCallback onTap;
  final UsernameClass usernameClass;
  final Database database;
  final TextEditingController controller;



  @override
  _AllJobsListTileState createState() => _AllJobsListTileState();
}

class _AllJobsListTileState extends State<AllJobsListTile> {
  @override

  Timer timer;
  String c = "";

  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
    super.initState();
  }

  final firestoreInstance = Firestore.instance;

  bool _isloading = false ;

  checkForNewSharedLists(){
    setState(() {
      c = widget.controller.text;
    });
  }


  @override
  Widget build(BuildContext context) {


    Future<Widget> _alertbox() async{

      setState(() {
        _isloading = true;
      });

      final collections = await widget.database
          .jobsStream(widget.usernameClass.username)
          .first;
      final allCollections = collections.map((job) => job.usernameof).toList();

      if(allCollections.contains(widget.job.usernameof)){
        Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 3),
          content: Text("User already exists on your chatbox."),
        ));
      }
      else{

        String url;
        String email;
        String storyurl;
        String storytext;
        String storytime;
        int storytimecheck;
        int storytimeint;
        String status;
        String name;

          firestoreInstance.collection ('allusers').document (
              widget.usernameClass.username ).get ( ).then ( ( value ) {
             url = value.data['urlof'];
             email = value.data['emailof'];
             status = value.data['statusof'];
             name = value.data['nameof'];
             storyurl = value.data['storyurlof'];
             storytext = value.data['storytextof'];
             storytime = value.data['timestr'];
             storytimecheck = value.data['storytimecheck'];
             storytimeint = value.data['storytimeof'];
             if(storytimecheck==null){
               storytimecheck=1;
             }
             if(storytimeint==null){
               storytimeint=1;
             }
          });





        final id = documentIdFromCurrentDate();
        final job1 = Reciever(
            id: widget.job.usernameof,urlof: widget.job.urlof , usernameof: widget.job.usernameof,statusof: widget.job.statusof  , nameof: widget.job.nameof,timeof:DateTime.now().millisecondsSinceEpoch , timejob: DateFormat.jm().format(DateTime.now()) , dateof : DateFormat("dd/MM/yyyy").format(DateTime.now()) ,
        storytimecheck: widget.job.storytimecheck , storytextof: widget.job.storytextof , emailof: widget.job.emailof, storyurlof: widget.job.storyurlof , timestr: widget.job.timestr , storytimeof : widget.job.storytimeof );
        await widget.database.setJob1(widget.usernameClass.username,job1);

        final job2 = Reciever(
            id: widget.usernameClass.username , urlof: url ,usernameof: widget.usernameClass.username, statusof: status, nameof: name == null ? widget.usernameClass.name : name , timeof: DateTime.now().millisecondsSinceEpoch , timejob: DateFormat.jm().format(DateTime.now()) , dateof : DateFormat("dd/MM/yyyy").format(DateTime.now()),
            storytimecheck: storytimecheck,emailof: email , storytextof: storytext , storyurlof: storyurl , timestr: storytime , storytimeof : storytimeint);
        await widget.database.setJob2(widget.job.usernameof,job2);
        Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 3),
          content: Text("User has been added to your chatbox."),
        ));
      }
      setState(() {
        _isloading = false;
      });
    }

    return widget.job.usernameof.contains(c) || widget.job.nameof.contains(c) ? Container(
      color: Colors.grey[300],
      height: 74,
      child: ListTile(
        leading : SizedBox(
          child: CircleAvatar(backgroundImage: widget.job.urlof == null ? AssetImage('images/${ widget.job.nameof[0]}.png') : NetworkImage('${widget.job.urlof}'),radius: 24,),
          height: 46,),
        title : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(widget.job.nameof.toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'HindMadurai',
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.person , color: Colors.grey[800],size: 22,),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    widget.job.usernameof.toString() ,
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
        ) ,

        onTap: widget.onTap,
        trailing: widget.job.usernameof != widget.usernameClass.username ? CircleAvatar(child: FlatButton(child:  _isloading == true ?  CircularProgressIndicator() : Icon(Icons.add , size: 28,), onPressed: _alertbox ),backgroundColor: Colors.grey[300] ,radius: 36,): SizedBox(),
      ),
    ) : SizedBox(height: 0,);
  }
}
