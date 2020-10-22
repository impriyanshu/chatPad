import 'dart:convert';
import'dart:io';
import 'package:chattingapp/Chat_screens/story_page/story.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/Chat_screens/chatbox.dart';
import 'package:chattingapp/add_pages/addamongall.dart';
import 'package:chattingapp/contacts/editinfo.dart';
import 'package:chattingapp/groups/group_username.dart';
import 'package:chattingapp/services/database.dart';
import 'package:chattingapp/signin_and_enterdetails/aboutme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../Modles/reciever.dart';
import 'jobs_list_tile.dart';
import 'list_item_builder.dart';

class HomePage extends StatefulWidget {

  HomePage({@required this.usernameClass, @required this.database});
  final UsernameClass usernameClass;
  final Database database;

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(milliseconds: 1100), _login);
    });
  }

  TextEditingController _searchcontroller = TextEditingController();

  Future _login() async{
    setState((){
      _loading = false;
    });
  }


  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    registerNotification();
    configLocalNotification();
    status();
    _onLoading();
    refreshList();
    super.initState();
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('allusers')
          .document(widget.usernameClass.username)
          .updateData({'token': token});
    }).catchError((err) {
      print(err);
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  String statuss;
  String emaill;
  String urll;
  String name;
  String token;
  int storycheckmine;

  var refreshKey = GlobalKey<RefreshIndicatorState>();


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    return null;
  }


  final firestoreInstance = Firestore.instance;

  void status() {
    firestoreInstance.collection('allusers').document(widget.usernameClass.username).get().then((value){
      statuss = value.data['statusof'];
      urll = value.data['urlof'];
      emaill = value.data['emailof'];
      name = value.data['nameof'];
      storycheckmine = value.data['storytimecheck'];
    });
  }

  String tokenuser(String username) {
    firestoreInstance.collection('allusers').document(username).get().then((value){
      token = value.data['token'];
    });
    return token;
  }




  Widget _buildContext(BuildContext context) {
    return StreamBuilder<List<Reciever>>(
      stream: widget.database.jobsStream(widget.usernameClass.username),
      builder: (context, snapshot) {
        return RefreshIndicator(
          key: refreshKey,
          child: ListItemsBuilder<Reciever>(
            snapshot: snapshot,
            itemBuilder: (context, job) => JobsListTile(
              job :  job,
              searchcontroller : _searchcontroller,
              onTap: () => ChatBox.show(context, job, widget.database, widget.usernameClass , tokenuser(job.usernameof) ),
              usernameClass: widget.usernameClass,
            ),
          ),
          onRefresh: refreshList,
        );
      },
    );
  }

  Widget appBarTitle = new Center(
    child: Row(
      children: <Widget>[
        Text('Chatbox',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,),
        SizedBox(width: 8,),
        Icon(Icons.chat)
      ],
    ),
  );

  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    status();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        title: appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: actionIcon,onPressed:(){
            setState(() {
              if ( this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.delete);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                  controller: _searchcontroller,
                  onChanged:  (value) {
                  },
                  decoration: new InputDecoration(
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white70)
                  ),
                );}
              else {
                this.actionIcon = new Icon(Icons.search);
                _searchcontroller.text='';
                this.appBarTitle = Center(
                  child: Row(
                    children: <Widget>[
                      Text('Chatbox',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                      SizedBox(width: 8,),
                      Icon(Icons.chat)
                    ],
                  ),
                );
              }


            });
          } ,),
          PopupMenuButton<int>(
            color: Color(0x00000000),
            elevation: 0,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                    color: Colors.green[200],
                    child: Text(
                      "Add User",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    onPressed: adduser,
                  ),
                ),
              ),

                    PopupMenuItem(
                    value: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: RoundedLoadingButton(
                          color: Colors.green[200],
                          child: Text(
                            "Create Group",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          onPressed: creategroup,
                        ),
                      ),
                    ),
              PopupMenuItem(
                value: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                      color: Colors.green[200],
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                            color: Colors.black , fontWeight: FontWeight.w500),
                      ),
                      onPressed: profilea
                  ),
                ),

              ),
              PopupMenuItem(
                value: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedLoadingButton(
                    color: Colors.green[200],
                    child: Text(
                      "Contact us",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AboutMe(),
                            fullscreenDialog: true
                        ),
                      );
                    },
                  ),
                ),
              ),

                  ],
            icon: Icon(Icons.more_vert),
            offset: Offset(0, 100),
          ),
          SizedBox(width: 15,)
        ],
      ),

      body: _buildContext(context),
      floatingActionButton: _loading == true ? Text('') :
          FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.camera,),
              onPressed : storydisp ,
          ),
    );
  }

  void profilea() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditInfo(usernameClass: UsernameClass(name: name , username: widget.usernameClass.username , status: statuss , url:  urll , email: emaill),),
          fullscreenDialog: true
      ),
    );
  }

  void adduser() {
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=> AddAmongAll(usernameClass : widget.usernameClass , database : widget.database),
          fullscreenDialog: true,
        )
    );
  }

    void creategroup() {
      Navigator.pop(context);
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context)=> GroupUsername(usernameClass : widget.usernameClass  , database : widget.database ),
            fullscreenDialog: true,
          )
      );
    }

  void storydisp() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context)=> StoryDisplay(database: widget.database , usernameClass: widget.usernameClass, storycheckmine: storycheckmine,),
          fullscreenDialog: true,
        )
    );
  }
}
