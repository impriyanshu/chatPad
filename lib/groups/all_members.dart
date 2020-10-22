import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/contacts/list_item_builder.dart';
import 'package:chattingapp/groups/all_members_tile.dart';
import 'package:chattingapp/services/database.dart';
import 'package:flutter/material.dart';

class AllMembers extends StatefulWidget {
  AllMembers({@required this.job , @required this.usernameClass , @required this.database});
  final Reciever job;
  final Database database;
  final UsernameClass usernameClass;

  @override
  _AllMembersState createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {

  Widget _buildContext(BuildContext context) {
    return StreamBuilder<List<Reciever>>(
      stream: widget.database.jobsStreamGroup(widget.usernameClass.username),
      builder: (context, snapshot) {
        return RefreshIndicator(
          key: refreshKey,
          child: ListItemsBuilder<Reciever>(
            snapshot: snapshot,
            itemBuilder: (context, job) => AddMembers_tile(
              database : widget.database,
              name : widget.job,
              job : job,
              usernameClass: widget.usernameClass,
              controller : _searchcontroller,
            ),
          ),
          onRefresh: refreshList,
        );
      },
    );
  }
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    refreshList();
    super.initState();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    return null;
  }


  Icon actionIcon = new Icon(Icons.search);

  Widget appBarTitle = new Center(
    child: Text('Add members',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,),
  );

  TextEditingController _searchcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    refreshList();
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
                      child: Text('Add members',
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
      body: _buildContext(context),
    );
  }
}
