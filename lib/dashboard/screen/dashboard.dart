import 'dart:async';

import 'package:demologin/dashboard/controller/dashboard_controller.dart';
import 'package:demologin/dashboard/model/log_model.dart';
import 'package:demologin/network/network_connect.dart';
import 'package:demologin/user/login/signin_page.dart';
import 'package:demologin/utils/shared_preference.dart';
import 'package:demologin/utils/store_file.dart';
import 'package:demologin/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';

class Dashboard extends StatefulWidget {
  Dashboard();
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnimation;
  Animation rotateAnimation;

  DashboardController _dashboardController = DashboardController();
  StoreFile _storeFile = StoreFile();
  LogModel _logModel;
  List productList = [];
  String selectedProduct;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 200));
    rotateAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(controller);

    listenStream();
    _dashboardController.todaysLog(NetworkConnect.currentUser.itemType);
    _dashboardController.userProducts();
    getTodaysLog();
    selectedProduct = NetworkConnect.currentUser.itemType;
  }

  listenStream() {
    _dashboardController.todaysLogStream.listen((event) {
      if (event['statusCode'] == 200)
        _logModel = LogModel.fromJSON(event['data']);
      setState(() {
        controller.stop();
        controller.reset();
      });
    });
    _dashboardController.userProductsStream.listen((event) {
      if (event['statusCode'] == 200) productList = event['data'];
      setState(() {});
    });
    _dashboardController.userMISStream.listen((event) async {
      if (event['statusCode'] == 200) {
        if (event['data'] != null) {
          var excel = Excel.createExcel();
          CellStyle cellStyle = CellStyle(
            bold: true,
            italic: true,
            fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
          );

          var sheet = excel[await excel.getDefaultSheet()];

          List allHeaders = ["createdTime"];

          event['data'].forEach((element) {
            element.keys.forEach((key) {
              if (!allHeaders.contains(key)) allHeaders.add(key);
            });
          });
          if (allHeaders.contains("total")) allHeaders.remove('total');
          allHeaders.add('total');
          sheet.appendRow(allHeaders);

          event['data'].forEach((element) {
            var row = [];
            allHeaders.forEach((header) {
              if (element[header] != null) {
                if (element[header].runtimeType == String ||
                    element[header].runtimeType == int)
                  row.add(element[header]);
                else
                  row.add(element[header]['count']);
              } else
                row.add(0);
            });
            sheet.appendRow(row);
          });

          String path = await _storeFile.inti(excel);
          EasyLoading.dismiss();
          final snackBar = SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                'File Store in $path',
                style: TextStyle(color: Colors.black),
              ));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // EasyLoading.showToast("File store in Downloads!");
        }
      }
      setState(() {});
    });
  }

  getTodaysLog() async {
    Timer.periodic(Duration(seconds: 8), (timer) {
      if (this.mounted) {
        _dashboardController
            .todaysLog(selectedProduct ?? NetworkConnect.currentUser.itemType);
      } else
        timer.cancel();
    });
  }

  logoutClicked() {
    SharedPrefManager.allClear();
    NetworkConnect.currentUser = null;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SingInPage()),
        (Route<dynamic> route) => false);
  }

  @override
  void dispose() {
    _dashboardController.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        title:
            Text(NetworkConnect.currentUser.companyName.capitalizeFirstofEach),
        centerTitle: true,
        actions: [
          AnimatedSync(
            animation: rotateAnimation,
            callback: () async {
              controller.forward();
              _dashboardController.todaysLog(
                  selectedProduct ?? NetworkConnect.currentUser.itemType);
            },
          ),
        ],
      ),
      body: _logModel == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          width: 300,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 20.0),
                            child: Text(
                              "Welcome " +
                                  NetworkConnect.currentUser.name.inCaps,
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
// //Sub Contractor Count
                  // Card(
                  //   clipBehavior: Clip.antiAlias,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Container(
                  //     color: Colors.black.withOpacity(.80),
                  //     child: Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                  //           child: Align(
                  //             alignment: Alignment.topLeft,
                  //             child: Text(
                  //               "Samoj Enterprises",
                  //               // subContractorCount.toString(),
                  //               style: TextStyle(
                  //                   fontSize: 50.0,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.orange),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 3.0,
                  // ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${NetworkConnect.currentUser.itemname.capitalizeFirstofEach}",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ), //Total requisition Count
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      // color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          DropdownButton(
                            underline: Container(color: Colors.transparent),
                            isExpanded: true,
                            items: productList
                                .map<DropdownMenuItem<String>>((value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedProduct = value;
                                _dashboardController.todaysLog(selectedProduct);
                              });
                            },
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                (selectedProduct ?? "").inCaps,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _logModel.loginTime != null
                                    ? "${DateFormat('hh : mm a').format(_logModel.loginTime)}"
                                    : "- : -",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 5.0),
                              child: Text(
                                "Machine Login Time",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ), //Total requisition Count
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${_logModel.hour ?? '-'} : ${_logModel.minutes ?? '-'}",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 5.0),
                              child: Text(
                                "Current Working Hours",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ), //Total requisition Count
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${_logModel.maskCreated}",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 5.0),
                              child: Text(
                                "Todays Production Count",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(.80),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${_logModel.createdInMonth}",
                                style: TextStyle(
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 5.0),
                              child: Text(
                                "Month Production",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          EasyLoading.show();
                          _dashboardController.getMISData();
                          // _storeFile.inti(excel);
                        },
                        child: Text('Export to Excel',
                            style: TextStyle(color: Color(0xffFFFFFF))),
                        padding: EdgeInsets.fromLTRB(75.0, 13.0, 75.0, 13.0),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => logoutClicked(),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                        color: Colors.blue,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 10),
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
    );
  }
}

class AnimatedSync extends AnimatedWidget {
  VoidCallback callback;
  AnimatedSync({Key key, Animation<double> animation, this.callback})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Transform.rotate(
      angle: animation.value,
      child: IconButton(
          icon: Icon(Icons.sync), // <-- Icon
          onPressed: () => callback()),
    );
  }
}
