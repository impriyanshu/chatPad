
import 'package:flutter/material.dart';

enum TabItem { search , accounts}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.search: TabItemData(title: 'Search', icon: Icons.search),
    TabItem.accounts: TabItemData(title: 'Accounts', icon: Icons.account_circle),
  };
}