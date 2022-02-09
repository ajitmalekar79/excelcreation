import 'dart:convert';

import 'package:demologin/user/model/user_model.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkConnect {
  static User currentUser;
  static bool isFingerActive = false;

  static String _baseUrl = 'https://samojenterprises.in/api/';

  static String userLogin = "users/signIn",
      todaysLog = 'tasks/todaysLog',
      getMISData = 'tasks/mis',
      userProducts = 'tasks/get-user-products';

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    FlutterRestart.restartApp();
  }

  Future sendPost(Map<String, dynamic> mapBody, String url) async {
    try {
      Map<String, String> headersData = Map<String, String>();
      headersData['Content-Type'] = "application/json";
      if (NetworkConnect.currentUser != null) {
        headersData['Authorization'] =
            'Bearer ' + NetworkConnect.currentUser.token;
        headersData['username'] = NetworkConnect.currentUser.name;
      }
      print("Url===$_baseUrl$url");
      http.Response response = await http.post(Uri.tryParse('$_baseUrl$url'),
          body: json.encode(mapBody), headers: headersData);
      var map = jsonDecode(response.body);
      if (response.statusCode == 401 || response.statusCode == 403 || map['statusCode'] == 401) {
        logoutUser();
      }
      return map;
    } catch (e) {
      Map<String, dynamic> map = {
        'error': 'Please Check Internet Connection!$e'
      };
      return map;
    }
  }

  Future<Map<String, dynamic>> sendGet(String url) async {
    try {
      Map<String, String> headersData = Map<String, String>();
      headersData['Content-Type'] = "application/json";
      if (NetworkConnect.currentUser != null) {
        headersData['Authorization'] =
            'Bearer ' + NetworkConnect.currentUser.token;
        // headersData['token'] = NetworkConnect.currentUser.token;
      }
      http.Response response =
          await http.get(Uri.tryParse('$_baseUrl$url'), headers: headersData);
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 401 || response.statusCode == 403 || map['statusCode'] == 401) {
        logoutUser();
      }

      return map;
    } catch (e) {
      print(e);
      Map<String, dynamic> map = {'error': 'Please Check Internet Connection!'};
      return map;
    }
  }

  Future<Map<String, dynamic>> post(
      Map<String, dynamic> mapBody, String url) async {
    try {
      Map<String, String> headersData = Map<String, String>();
      headersData['Content-Type'] = "application/json";
      if (NetworkConnect.currentUser != null) {
        headersData['Authorization'] =
            'Bearer ' + NetworkConnect.currentUser.token;
      }
      http.Response response = await http.post(
        Uri.tryParse('$_baseUrl$url'),
        body: json.encode(mapBody),
        headers: headersData,
      );
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 401 || response.statusCode == 403 || map['statusCode'] == 401) {
        logoutUser();
      }

      return map;
    } catch (e) {
      Map<String, dynamic> map = {'error': 'Please Check Internet Connection!'};
      return map;
    }
  }
}
