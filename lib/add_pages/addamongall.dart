import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/add_pages/alljobs_list_tile.dart';
import 'package:chattingapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Modles/reciever.dart';
import '../contacts/list_item_builder.dart';
import 'alljobstiledetail.dart';


class AddAmongAll extends StatefulWidget {
  AddAmongAll({@required this.usernameClass , @required this.database});
  final UsernameClass usernameClass;
  final Database database;

  @override
  _AddAmongAllState createState() => _AddAmongAllState();
}

class _AddAmongAllState extends State<AddAmongAll> {


  Timer timer;
  TextEditingController _searchcontroller = TextEditingController();


  @override
  void initState() {
    super.initState();
    refreshList();
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    return null;
  }

  Widget _buildContext(BuildContext context) {
    return StreamBuilder<List<Reciever>>(
      stream: widget.database.allJobsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return RefreshIndicator(
            key: refreshKey,
            child: ListItemsBuilder<Reciever>(
              snapshot: snapshot,
              itemBuilder: (context, job) =>
                  AllJobsListTile(
                    job: job,
                      onTap: ()=>  widget.usernameClass.username == job.usernameof ? (){} : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context)=> AllJobsTileDetail(job: job,),
                            fullscreenDialog: true,
                          )
                      ),
                    usernameClass: widget.usernameClass,
                    database: widget.database,
                    controller : _searchcontroller
                  ),
            ),
            onRefresh: refreshList,
          );
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

      },
    );
  }

  Icon actionIcon = new Icon(Icons.search);

  Widget appBarTitle = new Center(
    child: Text('You may also know',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[700],
          title: appBarTitle,
          centerTitle: true,
          actions: <Widget>[
            Row(
              children: <Widget>[
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
                        child: Text('You may also know',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                      );
                    }


                  });
                } ,),
                SizedBox(width : 18,)
              ],
            ),
          ],
        ),
        body: _buildContext(context)
    );
  }
}

