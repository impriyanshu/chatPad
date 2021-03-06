import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/customs/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class AccountPageGroup extends StatefulWidget {
  AccountPageGroup({@required this.job , @required this.group});
  final Reciever job ;
  final bool group ;



  @override
  _AccountPageGroupState createState() => _AccountPageGroupState();
}

class _AccountPageGroupState extends State<AccountPageGroup> {

  bool _isloading = false;


  File _image;
  String _uploadedFileURL;


  Future<Widget>  getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image !=null) {
      setState(() {
        _isloading=true ;
      });
      _image = image;
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
          .child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      print("Profile Picture uploaded");
      firebaseStorageRef.getDownloadURL().then((fileURL) {
        _uploadedFileURL = fileURL;
      });
      setState(() {
        _isloading = false;
      });
      print(_uploadedFileURL);

      showModalBottomSheet(context: context,
          builder: (BuildContext bc){
            return Container(
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    child: ListTile(
                        leading: new Icon(Icons.check_box , color: Colors.green,),
                        title: new Text('Update'),
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

  @override
  void initState() {
    status=widget.job.statusof;
    url=widget.job.urlof;
    name=widget.job.nameof;
    super.initState();
  }

  String status;
  String name;
  String url;

  final firestoreInstance = Firestore.instance;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    Future<void> setValue(String controller, String dept) async {
      if (controller.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
          content: Text("Field can't be empty"),
        ));
      }
      else {
        if (dept == 'name' && !(controller.codeUnitAt ( 0 ) >= 65 &&
            controller.codeUnitAt ( 0 ) <= 90) &&
            !(controller.codeUnitAt ( 0 ) >= 97 &&
                controller.codeUnitAt ( 0 ) <= 122)) {

          _scaffoldKey.currentState.showSnackBar (
              SnackBar (
                content: Text ( 'Name should start with an alphabet' ) ,
                duration: Duration ( seconds: 3 ) ,
              ) );

        }

        else{

        firestoreInstance.collection ( 'allgroups' ).document (
            widget.job.usernameof )
            .updateData ( {'${dept}' + 'of': controller} ).then ( ( _ ) {
          print ( 'success' );
        } );

        firestoreInstance.collection ( "allgroups" ).document (
            widget.job.usernameof ).collection ( 'users' )
            .getDocuments ( )
            .then ( ( querySnapshot ) {
          querySnapshot.documents.forEach ( ( result ) {
            firestoreInstance
                .collection ( "connect" )
                .document ( result.data['usernameof'] )
                .collection ( "jobs" )
                .document ( widget.job.usernameof )
                .updateData ( {'${dept}' + 'of': controller} ).then ( ( _ ) {
              setState ( ( ) {
                url = _uploadedFileURL;
              } );
            } );
          } );
        } );

        Navigator.pop ( context );
        setState ( ( ) {
          if (dept == 'status') {
            setState ( ( ) {
              status = controller;
            } );
          }
          else if (dept == 'name') {
            setState ( ( ) {
              name = controller;
            } );
          }
        } );
        _scaffoldKey.currentState.showSnackBar (
            SnackBar (
              content: Text ( '${dept} has been updated.' ) ,
              duration: Duration ( seconds: 3 ) ,
            ) );

        Navigator.pop ( context );
        Navigator.pop ( context );
      }

      }
    }


    Future<void> _alertDialogue(String dept) async {

      TextEditingController _controller = TextEditingController();
      if (dept=='status'){
        _controller.text = status;
      }
      else if (dept=='name'){
        _controller.text = name;
      }
      await showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter new ' + dept),
              content: TextFormField(
                controller: _controller,
                validator: (value) =>
                value.isNotEmpty
                    ? null
                    : "Value can't be empty",
                maxLength: dept == 'status' ? 120 : dept == 'name' ? 30 : 80,
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,

              ),

              actions: [
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () => setValue(_controller.text, dept),
                    ),

                  ],
                )
              ],
            );
          });
      _controller.clear();
    }


    Future<void> _coupertinoAlert(String dept) async {
      TextEditingController _controller = TextEditingController ( );
      if (dept == 'status') {
        _controller.text = status;
      }
      else if (dept == 'name') {
        _controller.text = name;
      }
      await showDialog ( context: context ,
          builder: ( context ) {
            return CupertinoAlertDialog (
              title: Text ( 'Enter new ' + dept ) ,
              content: TextFormField (
                controller: _controller ,
                validator: ( value ) =>
                value.isNotEmpty
                    ? null
                    : "Value can't be empty" ,
                maxLength: dept == 'status' ? 120 : dept == 'name' ? 30 : 80 ,
                buildCounter: ( BuildContext context ,
                    { int currentLength , int maxLength , bool isFocused } ) => null ,

              ) ,

              actions: [
                Row (
                  children: <Widget>[
                    FlatButton (
                      child: Text ( 'Cancel' ) ,
                      onPressed: ( ) => Navigator.pop ( context ) ,
                    ) ,
                    FlatButton (
                      child: Text ( 'Save' ) ,
                      onPressed: ( ) => setValue ( _controller.text , dept ) ,
                    ) ,

                  ] ,
                )
              ] ,
            );
          } );
      _controller.clear ( );
    }


    Widget _bodyinfo() {
      return Column(
        children: <Widget>[
          SizedBox(height: 30,),
          Center(child: Row(
            children: <Widget>[
              SizedBox(
                width: 160,
              ),
              Text(
                'Username',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 40,),

              SizedBox(
                  width: 60
              ),
            ],
          )),
          SizedBox(height: 5,),
          Text(
            widget.job.usernameof,
            style: GoogleFonts.acme(
              textStyle : TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.indigo[800],
              ),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              SizedBox(
                width: 175,
              ),
              Text(
                'Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 80,
              ),
              IconButton(icon: Icon(Icons.edit, color: Colors.indigo,),
                  onPressed: () =>
                  Platform.isIOS
                      ? _coupertinoAlert('status')
                      : _alertDialogue('status'))
            ],
          ),
          SizedBox(height: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AutoSizeText(
                  status != null ? status : "",
                  style: GoogleFonts.acme(
                    textStyle : TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo[800],
                    ),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget _buildUserInfo(BuildContext context) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 135,),
              Avatar(
                photoUrl: '${url}',
                radius: 65,
                name: widget.job.nameof,
                group: true,
              ),
              SizedBox(width: 60,),
              _isloading==true ? SpinKitFadingFour(color: Colors.white,) : IconButton(icon: Icon(Icons.edit, color: Colors.white,),
                  onPressed: ()=> getImage(context))
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 150,),
              Text(
                'Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700 , color: Colors.lightGreenAccent),
              ),
              SizedBox(
                width: 100,
              ),
              IconButton(icon: Icon(Icons.edit, color: Colors.white,),
                  onPressed: () => Platform.isIOS
                      ? _coupertinoAlert('name')
                      : _alertDialogue('name'))
            ],
          ),
          Text(
            name,
            style: GoogleFonts.acme(
              textStyle : TextStyle(
                  letterSpacing: 1,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo[50]
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      );
    }

    final RefreshController _refreshController = RefreshController();

    return SmartRefresher(
      controller : _refreshController,
      enablePullDown: true,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        _refreshController.refreshCompleted();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Group Info' , style: TextStyle(letterSpacing: 1 , fontWeight: FontWeight.w600 ),),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(260),
            child: _buildUserInfo(context),
          ),
        ),
        body: SingleChildScrollView(child: _bodyinfo()),
      ),
    );
  }




  void sendimage(BuildContext context) {

    if (_uploadedFileURL.isNotEmpty) {
      print(_uploadedFileURL);


      final firestoreInstance = Firestore.instance;

      firestoreInstance.collection("allgroups").document(widget.job.usernameof).collection('users').getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          firestoreInstance
              .collection("connect")
              .document(result.data['usernameof'])
              .collection("jobs")
              .document(widget.job.usernameof)
              .updateData({'urlof': _uploadedFileURL}).then((_) {
            setState(() {
              url = _uploadedFileURL;
            });
          });
        });
      });


      firestoreInstance.collection('allgroups').document(
          widget.job.usernameof)
          .updateData({'urlof': _uploadedFileURL}).then((_) {
        print('success');
        setState(() {
          url = _uploadedFileURL;
        });
      });
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Profile picture has been updated.'),
            duration: Duration(seconds: 3),
          ));
      print(_uploadedFileURL);

      Navigator.pop(context);
      Navigator.pop(context);
    }
  }


}


