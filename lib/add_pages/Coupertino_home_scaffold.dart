
import 'package:chattingapp/Modles/username.dart';
import 'package:chattingapp/add_pages/tab_item.dart';
import 'package:chattingapp/services/database.dart';
import 'package:flutter/material.dart';
import 'addamongall.dart';
import 'add_job_page.dart';
import 'home_multiplenav.dart';

class CoupertinoHomeScaffold extends StatefulWidget {
  CoupertinoHomeScaffold({@required this.database , @required this.usernameClass});
  final Database database;
  final UsernameClass usernameClass;

  @override
  _CoupertinoHomeScaffoldState createState() => _CoupertinoHomeScaffoldState();
}

class _CoupertinoHomeScaffoldState extends State<CoupertinoHomeScaffold> {
  TabItem _currentTab = TabItem.search;

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.search: (_) => AddJobPage(database: widget.database , usernameClass: widget.usernameClass,),
      TabItem.accounts: (_) => AddAmongAll(usernameClass : widget.usernameClass , database : widget.database),
    };
  }

  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(

      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }

}
