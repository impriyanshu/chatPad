import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:popup_box/popup_box.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class PersonalStory extends StatefulWidget {


  const PersonalStory({ Key key , @required this.job , this.mine , this.usernameClass , this.database}) : super(key : key);
  final Reciever job;
  final bool mine;
  final UsernameClass usernameClass;
  final Database database;

  static Future<void> show(BuildContext context, Reciever job , bool mine , UsernameClass usernameClass , Database database) async {
    await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => PersonalStory(job : job , mine: mine , usernameClass: usernameClass, database : database),
        )
    );
  }
  @override
  _PersonalStoryState createState() => _PersonalStoryState();
}

class _PersonalStoryState extends State<PersonalStory> with TickerProviderStateMixin {

  TextEditingController replycontroller = TextEditingController();
  String lastchatdate;


  @override
  void initState() {
    last();
    super.initState();
  }

  last(){
    firestoreInstance
        .collection ("connect")
        .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
      lastchatdate = value.data['chatdate'];
    });
  }

  final firestoreInstance = Firestore.instance;

  sendreply() {

    String msg = replycontroller.text;
    int chk=0;

    while(true){
      if ('${msg[0]}' == " "){
        msg= "${msg.substring(1)}";
      }
      else{
        chk=1;
        break;
      }
    }




    if (msg.isNotEmpty && chk == 1) {

      firestoreInstance
          .collection ("connect")
          .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
        lastchatdate = value.data['chatdate'];
      });


      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.usernameClass.username,
        "message": msg,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        "sendername" : widget.usernameClass.name,
        'isimage': false,
        'msgtime' : DateTime.now().millisecondsSinceEpoch ,
        'timeshow' : DateFormat.jm().format(DateTime.now()).toString(),
        'lastchatdate' : lastchatdate.toString(),
        'nowchatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
        'storyreply' : true
      };

      firestoreInstance
          .collection("connect")
          .document(widget.usernameClass.username)
          .collection('jobs')
          .document(widget.job.usernameof)
          .updateData({"timeof": DateTime
          .now()
          .millisecondsSinceEpoch , "timejob" : DateFormat.jm().format(DateTime.now()),
        "lastmsg" : msg,
        "lstphoto" : false,
        'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
        'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
      }).then((_) {
      });

      firestoreInstance
          .collection("connect")
          .document(widget.job.usernameof)
          .collection('jobs')
          .document(widget.usernameClass.username)
          .updateData({"timeof": DateTime
          .now()
          .millisecondsSinceEpoch , "timejob" : DateFormat.jm().format(DateTime.now()) , "lastmsg" : msg ,'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()), 'dateof' : DateFormat("dd/MM/yyyy",).format(DateTime.now()),
        "lstphoto" : false}).then((_) {
      });


      final String chatroomid1 = '${widget.usernameClass.username}_${widget
          .job
          .usernameof}';
      final String chatroomid2 = '${widget.job.usernameof}_${widget
          .usernameClass.username}';

      widget.database.addMessage(chatroomid1, chatMessageMap);
      widget.database.addMessage(chatroomid2, chatMessageMap);

      setState(() {
        replycontroller.text = "";
        msg="";
      });

    }

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: widget.mine==true ? AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Column(
          children: <Widget>[
            Text(
              'My story',
              style: TextStyle(
                fontWeight: FontWeight.w400
              ),
            ),
            SizedBox(width: 30,),
            Text(widget.job.timestr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300
            ),),
          ],
        ),
      ) : PreferredSize(preferredSize: Size(0.0, 0.0) , child: Container(),),

      body: widget.job.storytextof == "" ? FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 0),
        onPressed: (){
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Image.network(widget.job.storyurlof ,fit: BoxFit.fill,
                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ?
                          loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ): FlatButton(
        onPressed: (){
          Navigator.pop(context);
        },
        color: Colors.black,
        child: Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 70),
                  child: Image.network(widget.job.storyurlof ,fit: BoxFit.fill,
                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ?
                          loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AutoSizeText(widget.job.storytextof, style: GoogleFonts.aBeeZee(
                            textStyle : TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),
                          ) ,overflow: TextOverflow.ellipsis,maxLines: 4),
                        ),
                      ),
                      widget.mine==true ? SizedBox(height: 0,) : IconButton(icon : Icon(Icons.keyboard_arrow_up , color: Colors.white,) , onPressed: () async {
                        await PopupBox.showPopupBox(
                            context: context,
                            button: IconButton(
                              icon: Icon(Icons.send , color: Colors.teal,),
                              color: Colors.black,
                              onPressed: sendreply,
                            ),
                            willDisplayWidget: Column(
                              children: <Widget>[
                                Text(
                                  'Reply to story',
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: replycontroller,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.timelapse),
                                    labelText: 'Reply',
                                  ),
                                ),
                              ],
                            ));
                      },)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
