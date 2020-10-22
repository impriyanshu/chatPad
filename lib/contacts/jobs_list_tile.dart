import'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


class JobsListTile extends StatefulWidget {
  JobsListTile({Key key , @required this.job , @required this.onTap , @required this.usernameClass, name, @required this.searchcontroller}): super (key : key);
  final Reciever job ;
  final VoidCallback onTap;
  final UsernameClass usernameClass;
  final TextEditingController searchcontroller;

  @override
  _JobsListTileState createState() => _JobsListTileState();
}

class _JobsListTileState extends State<JobsListTile> {



  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
      new Future.delayed(new Duration(milliseconds: 800), _login);
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
    _onLoading();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
    super.initState();
  }


  checkForNewSharedLists(){
    setState(() {
      c = widget.searchcontroller.text;
    });
  }
  final firestoreInstance = Firestore.instance;


    @override
    Widget build(BuildContext context) {


    DateTime now = DateTime.now();
    DateTime diff = now.subtract(new Duration(hours: 24));
    int nowtime = diff.millisecondsSinceEpoch;

      return widget.job.nameof.toString().contains(c)||widget.job.lastmsg.toString().contains(c )|| widget.job.usernameof.contains(c ) ?  Container(
        color: Colors.grey[300],
        height: 74,
        child: ListTile(
          leading: SizedBox(
            child: CircleAvatar(
              backgroundImage : _loading == true ?  AssetImage('') : widget.job.isgroup == true  ? widget.job.urlof == null ? AssetImage('images/group_icon.png') : NetworkImage('${widget.job.urlof}') : widget.job.urlof == null ? AssetImage('images/${ widget.job.nameof.toString()[0]}.png') : NetworkImage('${widget.job.urlof}') , radius: 24,),
            height: 46,),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(widget.job.nameof.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'HindMadurai',
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(widget.job.lstphoto == true ? Icons.photo : widget.job.lastmsg == null ? Icons.person : Icons.chat , color: Colors.grey[800],size: 22,),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      widget.job.lastmsg == null ? widget.job.usernameof.toString() : widget.job.lastmsg,
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
          onTap: widget.onTap,
          trailing: Text(widget.job.timejob == null ? '' : widget.job.timeof > nowtime ?   widget.job.timejob : widget.job.dateof.toString() , style: TextStyle(fontWeight: FontWeight.w400),),
        ),
      ) : Container(height: 0,);
    }
}
