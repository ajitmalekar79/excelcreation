import 'package:flutter/material.dart';

enum TabItem { 
  // dashBoard, 
  yourwork, settings}

Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
  // TabItem.dashBoard: GlobalKey<NavigatorState>(),
  TabItem.yourwork: GlobalKey<NavigatorState>(),
  TabItem.settings: GlobalKey<NavigatorState>(),
  
};

Map<TabItem, String> tabName = {
  // TabItem.dashBoard: 'Dashboard',
  TabItem.yourwork: 'Your Work',
  TabItem.settings: 'Settings',
  
};
