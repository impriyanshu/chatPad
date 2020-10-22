import 'dart:async';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/Chat_screens/story_page/personal_story_view.dart';
import 'package:chattingapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobListTileStory extends StatefulWidget {
  JobListTileStory({Key key , @required this.job , @required this.onTap , @required this.usernameClass, name , this.time, this.searchcontroller , this.database}): super (key : key);
  final Reciever job ;
  final VoidCallback onTap;
  final UsernameClass usernameClass;
  final int time;
  final TextEditingController searchcontroller;
  final Database database;

  @override
  _JobListTileStoryState createState() => _JobListTileStoryState();
}

class _JobListTileStoryState extends State<JobListTileStory> {

  Timer timer;
  String c = "";

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
    super.initState();
  }



  checkForNewSharedLists(){
    setState(() {
      c = widget.searchcontroller.text;
    });
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    DateTime timediff = now.subtract(new Duration(hours: 24));
    int nowtime=timediff.millisecondsSinceEpoch;

    return widget.time > nowtime && widget.job.block == null && (widget.job.nameof.toString().contains(c) || widget.job.usernameof.contains(c)) ? SizedBox(
      height: 74,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: SizedBox(
            height: 55,
            width: 55,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.cyan,
                      width: 2
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.job.storyurlof), radius: 24,),
              ),

              height: 46,),
          ),
        ),
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
            SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.access_time),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    widget.job.timestr,
                    style: GoogleFonts.ubuntu(
                      textStyle : TextStyle(
                        fontSize: 18,
                          color: Colors.grey[800],
                        fontWeight: FontWeight.w500
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
        onTap : ()=>  PersonalStory.show (
            context , widget.job , false , widget.usernameClass , widget.database),
      ),
    )
        :
    SizedBox(
      height: 0,
    );
  }

}

