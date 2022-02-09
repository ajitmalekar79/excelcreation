import 'dart:async';

import 'package:demologin/network/network_connect.dart';
import 'package:intl/intl.dart';

class DashboardController {
  NetworkConnect _connect = NetworkConnect();

  Map<String, dynamic> mapBody = Map<String, dynamic>();

//------------------------Start------------------------------------------->>>
  final StreamController _todaysLogStreamController =
      StreamController.broadcast();

  StreamSink get todaysLogStreamSink => _todaysLogStreamController.sink;

  Stream get todaysLogStream => _todaysLogStreamController.stream;

//------------------------Start------------------------------------------->>>
  final StreamController _userProductsStreamController =
      StreamController.broadcast();

  StreamSink get userProductsStreamSink => _userProductsStreamController.sink;

  Stream get userProductsStream => _userProductsStreamController.stream;

  //------------------------Start------------------------------------------->>>
  final StreamController _userMISStreamController =
      StreamController.broadcast();

  StreamSink get userMISStreamSink => _userMISStreamController.sink;

  Stream get userMISStream => _userMISStreamController.stream;

//-------------------------------End---------------------------->>>

//Login User------>
  void todaysLog(String product) async {
    mapBody = Map<String, dynamic>();
    mapBody = {'username': NetworkConnect.currentUser.name, 'product': product};
    _connect.sendPost(mapBody, NetworkConnect.todaysLog).then((mapResponse) {
      todaysLogStreamSink.add(mapResponse);
    });
  }

  void userProducts() async {
    mapBody = Map<String, dynamic>();
    mapBody = {
      'username': NetworkConnect.currentUser.name,
    };
    _connect.sendPost(mapBody, NetworkConnect.userProducts).then((mapResponse) {
      userProductsStreamSink.add(mapResponse);
    });
  }

  void getMISData() async {
    mapBody = Map<String, dynamic>();
    DateTime today = DateTime.now();
    mapBody = {
      'username': NetworkConnect.currentUser.name,
      "from_date": "2021-06-01",
      "to_date": "${DateFormat('yyyy-MM-dd').format(today)}"
    };
    _connect.sendPost(mapBody, NetworkConnect.getMISData).then((mapResponse) {
          print("CellType: $mapResponse");
      userMISStreamSink.add(mapResponse);
    });
  }

  void destroy() {
    _todaysLogStreamController.close();
    _userProductsStreamController.close();
    _userMISStreamController.close();
  }
}
