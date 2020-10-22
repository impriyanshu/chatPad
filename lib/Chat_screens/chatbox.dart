import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/groups/all_members.dart';
import 'package:chattingapp/groups/view_participants.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'accountinfo.dart';
import '../groups/accountpage_group.dart';
import 'message_tile.dart';
import 'package:path/path.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({@required this.database, @required this.job, @required this.usernameClass, @required this.token});

  final Database database;
  final Reciever job;
  final UsernameClass usernameClass;
  final String token;




  static Future<void> show(BuildContext context, Reciever job,
      Database database, UsernameClass usernameClass, String token) async {
    await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: false,
          builder: (context) => ChatBox(database: database, job: job , usernameClass : usernameClass , token : token ),
        )
    );
  }

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {



  bool _loading = false;
  bool _isloading = false;

  String _uploadedFileURL;
  File _image;


  void scaffoldimage(BuildContext context){

    Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          Scaffold(
            appBar: AppBar(
              title: Text('Send'),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(icon: Icon(Icons.done , color: Colors.white,size: 25,),onPressed: ()=>sendimage(context)),
                )
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('$_uploadedFileURL')
                  )
              ),
            ),
          ),
    )
    );
  }

  Future<Widget> addimage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image !=null) {
      setState(() {
        _isloading = true;
      });
      _image = image;
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
          .child(
          fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      firebaseStorageRef.getDownloadURL().then((fileURL) {
        _uploadedFileURL = fileURL;
      });
      setState(() {
        _isloading = false;
      });


      showModalBottomSheet(context: context,
          builder: (BuildContext bc){
        return Container(
          child: Wrap(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: ListTile(
                    leading: new Icon(Icons.check_box , color: Colors.green,),
                    title: new Text('Send'),
                    onTap: () => sendimage(context)
                ),
              ),
              SizedBox(
                height: 60,
                child: ListTile(
                  leading: new Icon(Icons.error , color: Colors.red,),
                  title: new Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
          });
    }
  }


  void sendimage(BuildContext context) {


    if (_uploadedFileURL.isNotEmpty) {

      if(widget.job.isgroup==true) {
        firestoreInstance.collection ( 'allgroups' ).document (
            widget.job.usernameof ).get ( ).then ( ( value ) {
          lastsendermessage = value.data['lastsender'];
          lastchatdate = value.data['chatdate'];
        } );

      }
      else{
        firestoreInstance
            .collection ( "connect" )
            .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
          lastchatdate = value.data['chatdate'];
        });
      }

      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.usernameClass.username,
        "sendername" : widget.usernameClass.name,
        "message": _uploadedFileURL,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        'lastsender' : lastsendermessage.toString(),
        'isimage': true,
        'msgtime' : DateTime.now().millisecondsSinceEpoch,
        'timeshow' : DateFormat.jm().format(DateTime.now()).toString(),
        'lastchatdate' : lastchatdate.toString(),
        'nowchatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())
      };


      if(widget.job.isgroup == true){


        firestoreInstance
            .collection ( "allgroups" )
            .document ( widget.job.usernameof )
            .updateData ( {
          "lastsender": widget.usernameClass.username ,
          'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())
        } ).then ( ( _ ) {} );


        firestoreInstance.collection("allgroups").document(widget.job.usernameof).collection('users').getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            firestoreInstance
                .collection("connect")
                .document(result.data['usernameof'])
                .collection("jobs")
                .document(widget.job.usernameof)
                .updateData({"timeof": DateTime.now().millisecondsSinceEpoch , 'timejob' : DateFormat.jm().format(DateTime.now()) , "lastmsg" : "Photo",
              "lstphoto" : true , 'lastsender' : widget.usernameClass.username , 'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
              'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())}).then((_) {
            });
          });
        });

        final String chatroomid3 = '${widget.job.usernameof}';

        widget.database.addMessage(chatroomid3, chatMessageMap);

        setState(() {
          _textcontroller.text = "";
        });

      }

      else {
        firestoreInstance
            .collection("connect")
            .document(widget.usernameClass.username)
            .collection('jobs')
            .document(widget.job.usernameof)
            .updateData({"timeof": DateTime
            .now()
            .millisecondsSinceEpoch , 'timejob' : DateFormat.jm().format(DateTime.now()) , "lastmsg" : "Photo",
          "lstphoto" : true , 'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
          'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())}).then((_) {
        });

        firestoreInstance
            .collection("connect")
            .document(widget.job.usernameof)
            .collection('jobs')
            .document(widget.usernameClass.username)
            .updateData({"timeof": DateTime
            .now()
            .millisecondsSinceEpoch , 'timejob' : DateFormat.jm().format(DateTime.now()) , "lastmsg" : "Photo",
          "lstphoto" : true , 'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
          'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())}).then((_) {
        });


        final String chatroomid1 = '${widget.usernameClass.username}_${widget
            .job
            .usernameof}';
        final String chatroomid2 = '${widget.job.usernameof}_${widget
            .usernameClass.username}';

        widget.database.addMessage(chatroomid1, chatMessageMap);
        widget.database.addMessage(chatroomid2, chatMessageMap);

        setState(() {
          _textcontroller.text = "";
        });
      }

      Navigator.pop(context);

    }

    new Future.delayed(new Duration(milliseconds: 200), refresh);

  }

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(milliseconds: 1100), _login);
    });
  }


  Future _login() async {
    setState(() {
      _loading = false;
    });
  }

  final RoundedLoadingButtonController _clearchatController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _blockController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _removecontroller = new RoundedLoadingButtonController();


  Timer timer;
  bool sendmsg = true;

  @override
  void initState() {
    if(widget.job.isgroup == true){
      widget.database.getChats(
          '${widget.job.usernameof}').then((
          val) {
        setState(() {
          chats = val;
        });
      });
    }
    else {
      widget.database.getChats(
          '${widget.usernameClass.username}_${widget.job.usernameof}').then((
          val) {
        setState(() {
          chats = val;
        });
      });
    }
    _onLoading();
    statusgroup();
    status();

    date();
    timer = Timer.periodic(Duration(milliseconds: 2500), (Timer t) => checkForNewSharedLists());
    super.initState();
  }

  checkForNewSharedLists() {

    if(_controller.position.pixels  >=  (_controller.position.maxScrollExtent - 330) ) {
      Timer(
        Duration( microseconds: 10 ) ,
            ( ) => _controller.jumpTo( _controller.position.maxScrollExtent ) ,
      );
    }

  }


  date(){
    firestoreInstance
        .collection ( "connect" )
        .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
      lastchatdate = value.data['chatdate'];
    });
  }

  String statuss , statusgrp;
  String emaill , emailgrp , lastsendermessage , lastchatdate;
  String urll , urlgrp;
  String namee;


  final firestoreInstance = Firestore.instance;

  void statusgroup(){
    firestoreInstance.collection('allusers').document(
        widget.job.usernameof).get().then((value) {
      statuss = value.data['statusof'];
      urll = value.data['urlof'];
      emaill = value.data['emailof'];
      namee = value.data['nameof'];
    });
  }


  void status() {
    firestoreInstance.collection('allgroups').document(
        widget.job.usernameof).get().then((value) {
      statusgrp = value.data['statusof'];
      urlgrp = value.data['urlof'];
      emailgrp = value.data['emailof'];
    });
  }

  ScrollController _controller = ScrollController();
  TextEditingController _textcontroller = TextEditingController();
  Stream<QuerySnapshot> chats;

  addMessage() {

    String msg = _textcontroller.text;
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


      if(widget.job.isgroup==true) {
        firestoreInstance.collection ( 'allgroups' ).document (
            widget.job.usernameof ).get ( ).then ( ( value ) {
          lastchatdate = value.data['chatdate'];
        });
      }
      else{
        firestoreInstance
            .collection ( "connect" )
            .document ( widget.usernameClass.username ).collection('jobs').document(widget.job.usernameof).get ( ).then ( ( value ) {
          lastchatdate = value.data['chatdate'];
        });
      }

      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.usernameClass.username,
        "message": msg,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        "sendername" : widget.usernameClass.name,
        'isimage': false,
        'msgtime' : DateTime.now().millisecondsSinceEpoch ,
        'lastsender' : lastsendermessage.toString(),
        'timeshow' : DateFormat.jm().format(DateTime.now()).toString(),
        'lastchatdate' : lastchatdate.toString(),
        'nowchatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())
      };

      if(widget.job.isgroup == true){


        firestoreInstance
            .collection ( "allgroups" )
            .document ( widget.job.usernameof )
            .updateData ( {
          'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())
        } ).then ( ( _ ) {} );

        firestoreInstance.collection("allgroups").document(widget.job.usernameof).collection('users').getDocuments().then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            firestoreInstance
                .collection("connect")
                .document(result.data['usernameof'])
                .collection("jobs")
                .document(widget.job.usernameof)
                .updateData({"timeof": DateTime.now().millisecondsSinceEpoch , 'timejob' : DateFormat.jm().format(DateTime.now()) , "lastmsg" : msg,
              "lstphoto" : false , 'lastsender' : widget.usernameClass.username ,'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()) , 'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now())}).then((_) {
            });
          });
        });

        final String chatroomid3 = '${widget.job.usernameof}';

        widget.database.addMessage(chatroomid3, chatMessageMap);

        setState(() {
          _textcontroller.text = "";
        });

      }

      else {
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
          'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now())
        }).then((_) {
        });

        firestoreInstance
            .collection("connect")
            .document(widget.job.usernameof)
            .collection('jobs')
            .document(widget.usernameClass.username)
            .updateData({"timeof": DateTime
            .now()
            .millisecondsSinceEpoch , "timejob" : DateFormat.jm().format(DateTime.now()) , "lastmsg" : msg ,'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()), 'dateof' : DateFormat("dd/MM/yyyy").format(DateTime.now()),
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
          _textcontroller.text = "";
          msg="";
        });
      }
      
      new Future.delayed(new Duration(milliseconds: 200), refresh);

      setState(() {
        print('sent');
      });

    }

  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            controller: _controller,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: widget.usernameClass.username == snapshot.data.documents[index].data["sendBy"],
                isimage: snapshot.data.documents[index].data["isimage"],
                isgroup: widget.job.isgroup,
                sendby: snapshot.data.documents[index].data["sendername"],
                sending: snapshot.data.documents[index].data["sending"],
                sendTo: snapshot.data.documents[index].data["sendTo"],
                activity: snapshot.data.documents[index].data["activity"],
                time : widget.job.deletetime,
                msgtime : snapshot.data.documents[index].data["msgtime"],
                usernameClass : widget.usernameClass,
                lastsender : snapshot.data.documents[index].data["lastsender"],
                senderusername : snapshot.data.documents[index].data["sendBy"],
                  timeshow : snapshot.data.documents[index].data["timeshow"],
                lastchatdate : snapshot.data.documents[index].data["lastchatdate"],
                nowchatdate : snapshot.data.documents[index].data["nowchatdate"],
                storyreply : snapshot.data.documents[index].data["storyreply"],
                createdtime : snapshot.data.documents[index].data["createdtime"],
                creatednow : snapshot.data.documents[index].data["creatednow"],
                groupusernamename : snapshot.data.documents[index].data["groupusername"],
              );
            }) : Container();
      },
    );
  }

  blockdone(BuildContext context) {

    final firestoreInstance = Firestore.instance;


    if(widget.job.block==null) {
      firestoreInstance
          .collection ( "connect" )
          .document ( widget.usernameClass.username )
          .collection ( 'jobs' )
          .document ( widget.job.usernameof )
          .updateData ( {"block": 'blockme'} ).then ( ( _ ) {} );

      firestoreInstance
          .collection ( "connect" )
          .document ( widget.job.usernameof )
          .collection ( 'jobs' )
          .document ( widget.usernameClass.username )
          .updateData ( {"block": 'blockhe'} ).then ( ( _ ) {} );
    }
    else {
      firestoreInstance
          .collection ( "connect" )
          .document ( widget.usernameClass.username )
          .collection ( 'jobs' )
          .document ( widget.job.usernameof )
          .updateData ( {"block": null} ).then ( ( _ ) {} );

      firestoreInstance
          .collection ( "connect" )
          .document ( widget.job.usernameof )
          .collection ( 'jobs' )
          .document ( widget.usernameClass.username )
          .updateData ( {"block": null} ).then ( ( _ ) {} );
    }


    Navigator.pop (context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    date();
    statusgroup();
    status();

    Timer(
      Duration(seconds: 1),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );

    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          backgroundColor: Colors.indigo[700],
          title:
              Text(widget.job.nameof.toString(), style: TextStyle(
                fontSize: 20,
                color: Colors.indigo[50],
              ), overflow: TextOverflow.ellipsis,),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10
              ),
              child: _loading == true ? null :
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.info, color: Colors.indigo[50]),
                      onPressed: () =>
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  widget.job.isgroup != true ? AccountPage(
                                    job: widget.job,
                                    group: widget.job.isgroup == true ? true : false,
                                  ) : AccountPageGroup(
                                    job: widget.job,
                                    group: widget.job.isgroup == true ? true : false,
                                  ) ,
                              fullscreenDialog: true,
                            ),
                          )) ,
                        widget.job.isgroup == true
                            ? PopupMenuButton<int>(
                                color: Color(0x00000000),
                                elevation: 0,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RoundedLoadingButton(
                                          color: Colors.green[100],
                                          child: Text(
                                            "Add Members",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AllMembers(job : widget.job , usernameClass : widget.usernameClass , database : widget.database),
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RoundedLoadingButton(
                                        color: Colors.green[100],
                                        child: Text(
                                          "View Members",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed :(){
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewParticipants(job : widget.job , usernameClass : widget.usernameClass , database : widget.database),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RoundedLoadingButton(
                                        controller: _btnController,
                                        color: Colors.green[100],
                                        child: Text(
                                          "Exit Group",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed :(){
                                          _btnController.reset();
                                          Platform.isIOS ? _coupertinoAlert(context) : _alertDialogue(context);

                                        },
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RoundedLoadingButton(
                                        color: Colors.green[100],
                                        child: Text(
                                          "Clear Chat",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () async {
                                          Platform.isIOS ? await showDialog(context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Confirmation'),
                                                  content: Text(
                                                'Delete chat of group ' + '${widget.job.usernameof}' + '?'),
                                                  actions: [
                                                    Row(
                                                      children: <Widget>[
                                                        FlatButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () => Navigator.pop(context),
                                                        ),
                                                        FlatButton(
                                                            child: Text('Delete'),
                                                            onPressed: ()=> _deleteChat(context),

                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }) :
                                          await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Confirmation'),
                                                      content: Text(
                                                          'Delete chat of group ' + '${widget.job.usernameof}' + '?'),
                                                      actions: [
                                                        Row(
                                                          children: <Widget>[
                                                            FlatButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            ),
                                                            FlatButton(
                                                              child:
                                                                  Text('Delete'),
                                                              onPressed: () =>
                                                              _deleteChat(context),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                                icon: Icon(Icons.more_vert),
                                offset: Offset(0, 100),
                              ) : widget.job.block != 'blockhe'? PopupMenuButton<int>(
                          color: Color(0x00000000),
                          elevation: 0,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedLoadingButton(
                                  controller: _clearchatController,
                                    color: Colors.green[100],
                                    child: Text(
                                      "Clear Chat",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () async {
                                      _clearchatController.reset();
                                      Platform.isIOS ? await showDialog(context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text('Confirmation'),
                                              content: Text(
                                                  'Delete chat with ' + '${widget.job.usernameof}' + '?'),
                                              actions: [
                                                Row(
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                    FlatButton(
                                                      child: Text('Delete'),
                                                      onPressed: ()=> _deleteChat(context),

                                                    ),
                                                  ],
                                                ),
                                                          ],
                                                        );
                                                      })
                                                  : await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirmation'),
                                                          content: Text(
                                                              'Delete chat with ' +
                                                                  '${widget.job.usernameof}' +
                                                                  '?'),
                                                          actions: [
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                      'Cancel'),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                      'Delete'),
                                                                  onPressed: () =>
                                                                      _deleteChat(
                                                                          context),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      });
                                              Navigator.pop(context);
                                    },
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedLoadingButton(
                                  controller: _removecontroller,
                                  color: Colors.green[100],
                                  child: Text(
                                    "Remove",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                      _removecontroller.reset();
                                    Platform.isIOS ? await showDialog(context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: Text('Confirmation'),
                                              content: Text('Remove user from your chatbox ?'),
                                              actions: [
                                                Row(
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                    FlatButton(
                                                        child: Text('Remove'),
                                                        onPressed: ()=>  confiremdelete(context)
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }) :
                                          await showDialog(context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Confirmation'),
                                              content: Text('Remove user from your chatbox ?'),
                                              actions: [
                                                Row(
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () => Navigator.pop(context),
                                                    ),
                                                    FlatButton(
                                                      child: Text('Remove'),
                                                      onPressed: () => confiremdelete(context),
                                                    ),

                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    Navigator.pop(context);

                                  },
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedLoadingButton(
                                  controller: _blockController,
                                  color: Colors.green[100],
                                  child: Text(
                                    widget.job.block == 'blockme' ? "Unblock" : "Block",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: (){
                                    _blockController.reset();
                                    showModalBottomSheet(context: context,
                                        builder: (BuildContext bc){
                                          return Container(
                                            child: Wrap(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 60,
                                                  child: ListTile(
                                                      leading: widget.job.block == 'blockme' ?   Icon(Icons.play_circle_filled , color: Colors.green,) : Icon(Icons.block , color: Colors.red,),
                                                      title: widget.job.block == 'blockme' ?   Text('Unblock')  :  Text('Block'),
                                                      onTap: () => blockdone(context)

                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 60,
                                                  child: ListTile(
                                                    leading: new Icon(Icons.clear , color: Colors.green,),
                                                    title: new Text('Cancel'),
                                                    onTap: () => backpage(context)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),

                          ],
                          icon: Icon(Icons.more_vert),
                          offset: Offset(0, 100),
                        ) : PopupMenuButton<int>(
                          color: Color(0x00000000),
                          elevation: 0,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundedLoadingButton(
                                  controller: _clearchatController,
                                  color: Colors.green[100],
                                  child: Text(
                                    "Delete Chat",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    _clearchatController.reset();
                                    Platform.isIOS ? await showDialog(context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text('Confirmation'),
                                            content: Text(
                                                'Delete chat with ' + '${widget.job.usernameof}' + '?'),
                                            actions: [
                                              Row(
                                                children: <Widget>[
                                                  FlatButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () => Navigator.pop(context),
                                                  ),
                                                  FlatButton(
                                                    child: Text('Delete'),
                                                    onPressed: ()=> _deleteChat(context),

                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        })
                                        : await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Confirmation'),
                                            content: Text(
                                                'Delete chat with ' +
                                                    '${widget.job.usernameof}' +
                                                    '?'),
                                            actions: [
                                              Row(
                                                children: <
                                                    Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                        'Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context),
                                                  ),
                                                  FlatButton(
                                                    child: Text(
                                                        'Delete'),
                                                    onPressed: () =>
                                                        _deleteChat(
                                                            context),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                          offset: Offset(0, 100),
                        ),
                      ],
              ),

            )
          ],
        ),
        body: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: chatMessages(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: widget.job.block!=null ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(child: Text(widget.job.block=='blockme' ?  'Unblock user to continue chat ' : "You have been blocked , can't send messages  " , style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                  ),),),
                )  : Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.only(
                      left: 10, top: 10, right: 30, bottom: 15),
                  child: SizedBox(
                    height: 42,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textcontroller,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            onChanged: (value) => value,
                            decoration: InputDecoration(
                              hintText: 'Type a message ...',
                              hintStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            _isloading == false ? IconButton(icon: SizedBox(height: 80,
                                width: 40,
                                child: CircleAvatar(child: Center(
                                    child: Icon(Icons.camera_alt)),
                                    foregroundColor: Colors.indigo[50],
                                    backgroundColor: Colors.white10)),
                              onPressed:()=> addimage(context),) : SpinKitFadingFour(color: Colors.white,),
                            IconButton(icon: SizedBox(height: 80,
                                width: 10,
                                child: CircleAvatar(
                                    child: Center(child: Icon(Icons.send)),
                                    foregroundColor: Colors.indigo[50],
                                    backgroundColor: Colors.white10)),
                              onPressed: addMessage ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
  Future<void> _alertDialogue(BuildContext context) async {
    await showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: RichText(
              text: TextSpan(
                  text: 'Exit group ' ,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.job.nameof}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ]),
            ),
            actions: [
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text('Exit'),
                    onPressed: () => _submit(context),
                  ),

                ],
              )
            ],
          );
        });

    Navigator.pop(context);


  }


  Future<void> _coupertinoAlert(BuildContext context) async {

    await showDialog(context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Confirmation'),
            content: Row(children: <Widget>[Text('Exit Group ') , Text('${widget.job.nameof}' , style: TextStyle( fontWeight: FontWeight.w700 ),)],),
            actions: [
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text('Exit'),
                    onPressed: ()=>  _submit(context)
                  ),
                ],
              ),
            ],
          );
        });

    Navigator.pop(context);


  }


  void _submit(BuildContext context ) {

    firestoreInstance.collection('connect').document('${widget.usernameClass.username}')
        .collection('jobs').document('${widget.job.usernameof}').delete().then((_){
    });

    firestoreInstance.collection('allgroups').document('${widget.job.usernameof}')
        .collection('users').document('${widget.usernameClass.username}').delete().then((_){
    });

    Map<String, dynamic> chatMessageMap = {
      "sendBy": widget.usernameClass.username,
      "message" : "",
      "isgroup" : true,
      "isimage" : false,
      "sendTo" : widget.job.nameof,
      "sendername" : widget.usernameClass.name,
      'time': DateTime
          .now()
          .millisecondsSinceEpoch,
      'sending' : true,
      'activity' : true,
      'time': DateTime
          .now()
          .millisecondsSinceEpoch,
      'lastsender' : 'no',
      'msgtime' : DateTime.now().millisecondsSinceEpoch,

    };

    widget.database.addMessage(widget.job.usernameof, chatMessageMap);


    Navigator.pop(context);
    Navigator.pop(context);

  }

  void _deleteChat(BuildContext context) {

    if(widget.job.isgroup == true){

      firestoreInstance
          .collection("connect")
          .document(widget.usernameClass.username)
          .collection('jobs')
          .document(widget.job.usernameof)
          .updateData({"deletetime": DateTime.now()
          .millisecondsSinceEpoch , "lastmsg" : null , "lstphoto" : false }).then((_) {
      });

      Navigator.pop(context);

    }

    else {
      firestoreInstance.collection ( 'chatlink' ).document (
          '${widget.usernameClass.username}_${widget.job.usernameof}' )
          .collection ( 'chat' ).getDocuments ( )
          .then ( ( snapshot ) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete ( );
        }
      });

      firestoreInstance
          .collection("connect")
          .document(widget.usernameClass.username)
          .collection('jobs')
          .document(widget.job.usernameof)
          .updateData({"lastmsg" : null , "lstphoto" : false , 'chatdate' : DateFormat("dd/MM/yyyy").format(DateTime.now()) }).then((_) {
      });

      Navigator.pop(context);

    }

    Navigator.pop(context);

  }

  void refresh() {
    Timer(
      Duration(microseconds: 10),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
  }

  void confiremdelete(BuildContext context) {

    Navigator.pop(context);
    Navigator.pop(context);


    firestoreInstance.collection("connect").document(widget.usernameClass.username).collection('jobs').document(widget.job.usernameof).delete().then((_) {
      print("success!");
    });

    firestoreInstance.collection("connect").document(widget.job.usernameof).collection('jobs').document(widget.usernameClass.username).delete().then((_) {
      print("success!");
    });


    firestoreInstance.collection ( 'chatlink' ).document (
        '${widget.usernameClass.username}_${widget.job.usernameof}' )
        .collection ( 'chat' ).getDocuments ( )
        .then ( ( snapshot ) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete ( );
      }
    });

    firestoreInstance.collection ( 'chatlink' ).document (
        '${widget.job.usernameof}_${widget.usernameClass.username}' )
        .collection ( 'chat' ).getDocuments ( )
        .then ( ( snapshot ) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete ( );
      }
    });

  }

  backpage(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
  }

}


