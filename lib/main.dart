import 'package:demologin/dashboard/screen/dashboard.dart';
import 'package:demologin/user/login/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

import 'network/network_connect.dart';
import 'utils/shared_preference.dart';

void main() {
  Stetho.initialize();
  SharedPrefManager.getSharedPref().then((value) {
    SharedPrefManager.getCurrentUser().then((value) {
      if (value != null) {
        NetworkConnect.currentUser = value;
      }
    });
    runApp(MyApp());
  });
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.orange),
      builder: EasyLoading.init(),
      home: NetworkConnect.currentUser != null ? Dashboard() : SingInPage(),
    );
  }
}
