import 'dart:io';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/Chat_screens/story_page/job_list_tile_story.dart';
import 'package:chattingapp/contacts/list_item_builder.dart';
import 'package:chattingapp/Chat_screens/story_page/personal_story_view.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StoryDisplay extends StatefulWidget {
  StoryDisplay({@required this.database , @required this.usernameClass , @required this.storycheckmine});
  final  Database database;
  final UsernameClass usernameClass;
  final int storycheckmine;


  static String storyurl;
  static String storytext;
  static String storytime;
  static int storytimecheck;


  @override
  _StoryDisplayState createState() => _StoryDisplayState();
}

class _StoryDisplayState extends State<StoryDisplay> with TickerProviderStateMixin {
  @override
  AnimationController _controllerani;
  static const List<IconData> icons = const [
    Icons.photo_album ,
    Icons.camera_alt
  ];


  String caption;
  final TextEditingController _usernameController = TextEditingController();
  String _storytext;
  int storychk;

  @override
  void initState ( ) {
    storychk = widget.storycheckmine;
    print(widget.storycheckmine);
    refreshList ( );
    _onLoading ( );
    urll ( );
    super.initState ( );
  }


  Widget appBarTitle = new Center(
    child: Row(
      children: <Widget>[
        Text('Stories',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,),
        SizedBox(width: 8,),
        Icon(Icons.timelapse)
      ],
    ),
  );
  Icon actionIcon = new Icon(Icons.search);

  TextEditingController _searchcontroller = TextEditingController();


  var refreshKey = GlobalKey<RefreshIndicatorState> ( );

  final firestoreInstance = Firestore.instance;

  void urll () {
    firestoreInstance.collection ( 'allusers' ).document (
        widget.usernameClass.username ).get ( ).then ( ( value ) {
      StoryDisplay.storyurl = value.data['storyurlof'];
      StoryDisplay.storytext = value.data['storytextof'];
      StoryDisplay.storytime = value.data['timestr'];
      StoryDisplay.storytimecheck = value.data['storytimecheck'];
      if(StoryDisplay.storytimecheck==null){
        StoryDisplay.storytimecheck=1;
      }
    });
  }

  bool _loading = false;

  void _onLoading () {
    setState ((){
      _loading = true;
      new Future.delayed( new Duration( milliseconds: 1100 ) , _login );
    });
  }


  Future _login ( ) async {
    setState ( ( ) {
      _loading = false;
    } );
  }


  Future<Null> refreshList () async {
    refreshKey.currentState?.show ( atTop: false );
    await Future.delayed ( Duration ( seconds: 2 ) );
    return null;
  }

  Widget build ( BuildContext context ) {
    DateTime now = DateTime.now();
    DateTime timediff = now.subtract(new Duration(hours: 24));
    int nowtime=timediff.millisecondsSinceEpoch;


    Widget _buildContext ( BuildContext context ) {
      return StreamBuilder<List<Reciever>> (
        stream: widget.database.storyStream ( widget.usernameClass.username ) ,
        builder: ( context , snapshot ) {
          return RefreshIndicator(
            key: refreshKey,
            child: ListItemsBuilder<Reciever> (
              snapshot: snapshot ,
              itemBuilder: ( context , job ) =>
                  JobListTileStory(
                      job: job ,
                      onTap: ( ) => ( ) {},
                      time : job.storytimeof == null ? 1 :job.storytimeof,
                      searchcontroller : _searchcontroller,
                      database: widget.database,
                    usernameClass: widget.usernameClass,
                  ) ,
            ),
            onRefresh: refreshList,
          );
        } ,
      );
    }

    Color backgroundColor = Theme
        .of ( context )
        .cardColor;
    Color foregroundColor = Theme
        .of ( context )
        .accentColor;

    return Scaffold (
      appBar: AppBar (
        title: appBarTitle,
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
                      Text('Stories',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                      SizedBox(width: 8,),
                      Icon(Icons.timelapse)
                    ],
                  ),
                );
              }


            });
          } ,),
          SizedBox(width: 15,),
          storychk  > nowtime && _loading == false ?   Row(
            children: <Widget>[
              IconButton(icon : Icon(Icons.history),iconSize: 30 , onPressed: (){
                PersonalStory.show(context, Reciever(storytextof: StoryDisplay.storytext , storyurlof: StoryDisplay.storyurl , timestr : StoryDisplay.storytime ) , true, widget.usernameClass , widget.database);
              }),
              SizedBox(width: 15,)
            ],
          ) : SizedBox()
        ],
        centerTitle: true ,
      ) ,
      body: _buildContext ( context ) ,
      floatingActionButton: _isloading == true ? SpinKitCircle(color: Colors.cyan,size: 60,) : SpeedDial (
        animatedIcon: AnimatedIcons.play_pause ,
        animatedIconTheme: IconThemeData ( size: 25.0 ) ,
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        curve: Curves.bounceIn ,
        overlayColor: Colors.black ,
        overlayOpacity: 0.5 ,
        onOpen: ( ) => print ( 'OPENING DIAL' ) ,
        onClose: ( ) => print ( 'DIAL CLOSED' ) ,
        tooltip: 'Speed Dial' ,
        heroTag: 'speed-dial-hero-tag' ,
        backgroundColor: Colors.cyan ,
        foregroundColor: Colors.white ,
        elevation: 8.0 ,
        shape: CircleBorder ( ) ,
        children: [
          SpeedDialChild (
            child: Icon ( Icons.photo ) ,
            backgroundColor: Colors.purpleAccent ,
            onTap: ( ) => addimage ( context ) ,
          ) ,
        ] ,
      ) ,
    );
  }


  String _uploadedFileURL;
  File _image;
  bool _isloading = false;
  File image;


  Future<Widget> addimage ( BuildContext context ) async {
    image = await ImagePicker.pickImage ( source: ImageSource.gallery);
    if (image != null) {
      setState (( ) {
        _isloading = true;
      } );
      _image = image;
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref ( )
        .child (
        filename );
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL ( ).then (( fileURL ) {
      _uploadedFileURL = fileURL;
    });
    setState (( ) {
      _isloading = false;
    } );

      Alert(
          context: context,
          title: "Caption",
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.mode_edit),
                  labelText: 'Add caption...',
                ),
                maxLength: 150,
                onSaved: (value) => caption = value,
              ),
            ],
          ),
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(50),
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.close , color: Colors.white,),
              color: Colors.red,
            ),
            DialogButton(
              radius: BorderRadius.circular(50),
              onPressed: () => sendimage(context),
              child: Icon(Icons.check_box , color: Colors.white,),
              color: Colors.green,
            ),

          ]).show();

    }
}


  Future<void> sendimage(BuildContext context) async {

    String msg=_usernameController.text;
    if (_uploadedFileURL.isNotEmpty) {

      firestoreInstance.collection("connect").document(widget.usernameClass.username).collection('jobs').getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          firestoreInstance
              .collection("connect")
              .document(result.data['usernameof'])
              .collection("jobs")
              .document(widget.usernameClass.username)
              .updateData({"storyurlof": _uploadedFileURL , "isstoryof" : true , 'storytextof' : msg , "storytimecheck" : DateTime.now().millisecondsSinceEpoch,
            'storytimeof' : DateTime.now().millisecondsSinceEpoch , 'timestr' : DateFormat.jm().format(DateTime.now()) , 'storyadder' : DateTime.now().millisecondsSinceEpoch}).then((_) {
          });
        });
      });

      setState(() {
        storychk = DateTime.now().millisecondsSinceEpoch;
      });

      firestoreInstance.collection("allusers").document(widget.usernameClass.username).updateData(
          {
            "storyurlof" : _uploadedFileURL,
            "storytextof" : msg,
            "timestr" : DateFormat.jm().format(DateTime.now()),
            "storytimecheck" : DateTime.now().millisecondsSinceEpoch,
            'storyadder' : DateTime.now().millisecondsSinceEpoch,
            'storytimeof' : DateTime.now().millisecondsSinceEpoch,
            "isstoryof" : true
          }).then((_){
      });
    }

      _onLoading();
      urll();
      _usernameController.clear();
      Navigator.pop(context);

    }
  }

