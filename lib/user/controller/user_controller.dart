import 'dart:async';

import 'package:demologin/network/network_connect.dart';

class UserController {
  NetworkConnect _connect = NetworkConnect();

  Map<String, dynamic> mapBody = Map<String, dynamic>();

//------------------------Start------------------------------------------->>>
  final StreamController _loginStreamController = StreamController.broadcast();

  StreamSink get loginStreamSink => _loginStreamController.sink;

  Stream get loginStream => _loginStreamController.stream;

//-------------------------------End---------------------------->>>

//Login User------>
  void checkLogin(String username, String password) async {
    mapBody = Map<String, dynamic>();
    mapBody = {"username": username.trim(), "password": password.trim()};
    _connect.sendPost(mapBody, NetworkConnect.userLogin).then((mapResponse) {
      loginStreamSink.add(mapResponse);
    });
  }

  void destroy() {
    _loginStreamController.close();
  }
}
