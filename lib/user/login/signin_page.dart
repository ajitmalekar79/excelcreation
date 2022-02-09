import 'dart:convert';

import 'package:demologin/dashboard/screen/dashboard.dart';
import 'package:demologin/user/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/user_model.dart';
import '../../utils/navigation.dart';
import '../../utils/shared_preference.dart';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final fromKey = GlobalKey<FormState>();

  UserController _userController = UserController();
  TextEditingController controllerEmail = new TextEditingController(
      // text: "nikit"
      );
  TextEditingController controllerPass = new TextEditingController(
      // text: "nikit@123"
      );

  OutlineInputBorder outlineInputBorderBox = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      width: 2,
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  );

  bool _isPasswordVisible = true;

  FocusNode _emailFocus = FocusNode(), _passwordFocus = FocusNode();
  ScrollController _scrollController = ScrollController();

  bool autoValidate = false, autoValidatePass = false, _isAccSelected = false;

  double _screenHeight;

  @override
  void initState() {
    super.initState();
    listenStream();
  }

  listenStream() {
    _userController.loginStream.listen((event) {
      // Map<String, dynamic> responseData = jsonDecode(event);
      if (EasyLoading.isShow) EasyLoading.dismiss();
      if (event != null) {
        if (event['statusCode'] == 200) {
          User _loggedInUser = User();
          _loggedInUser = User.fromJSON(event);
          SharedPrefManager.setCurrentUser(_loggedInUser);
          NavigationActions.navigateRemoveUntil(context, Dashboard());
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             Dashboard(token: responseData['apiKey'])));
        } else
          EasyLoading.showToast("Invalid Credentials!");
      }
    });
  }

  clearData() {
    autoValidate = false;
    autoValidatePass = false;
    _isAccSelected = false;
    controllerEmail = TextEditingController();
    controllerPass = TextEditingController();
    _emailFocus.requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Container(
              height: _screenHeight,
              child: Form(
                key: fromKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 7),
                        // setPenzylLogo(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 20),
                        Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(fontSize: 40, color: Colors.amber),
                          ),
                        ),
                        // textHeadTitle('Log In'),
                        SizedBox(height: _screenHeight / 24),
                        Text(
                          "Username",
                          style: TextStyle(fontSize: 20, color: Colors.amber),
                        ),
                        // textTittle("Email Id"),
                        SizedBox(
                          height: _screenHeight / (40 * 2),
                        ),
                        TextFormField(
                          controller: controllerEmail,
                          autovalidate: autoValidate,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 20, top: 30),
                              labelText: 'Enter Username',
                              hasFloatingPlaceholder: false,
                              labelStyle: TextStyle(color: Color(0xff97A6BA)),
                              border: outlineInputBorderBox,
                              focusedBorder: outlineInputBorderBox),
                          validator: (value) {
                            if (value.trim().length == 0) {
                              return "Enter Username";
                            }
                            return null;
                          },
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                            _scrollController.animateTo(_screenHeight / 15,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                        ),
                        SizedBox(
                          height: _screenHeight / (20 * 2),
                        ),
                        Text(
                          "Password",
                          style: TextStyle(fontSize: 20, color: Colors.amber),
                        ),
                        // textTittle("Password"),
                        SizedBox(
                          height: _screenHeight / (40 * 2),
                        ),
                        TextFormField(
                          controller: controllerPass,
                          obscureText: _isPasswordVisible,
                          autovalidate: autoValidatePass,
                          focusNode: _passwordFocus,
                          decoration: InputDecoration(
                            hasFloatingPlaceholder: false,
                            contentPadding: EdgeInsets.only(left: 20, top: 30),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _isPasswordVisible
                                    ? Colors.grey
                                    : Colors.amber,
                              ),
                              onPressed: () {
                                _isPasswordVisible = !_isPasswordVisible;
                                setState(() {});
                              },
                            ),
                            labelText: 'Enter Password',
                            labelStyle: TextStyle(color: Color(0xff97A6BA)),
                            border: outlineInputBorderBox,
                            focusedBorder: outlineInputBorderBox,
                          ),
                          validator: (value) {
                            if (value.trim().length == 0) {
                              return "Enter Password";
                            }
                            return null;
                          },
                          onTap: () {
                            Future.delayed(Duration(milliseconds: 200), () {
                              _scrollController.animateTo(_screenHeight / 15,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            });
                          },
                          onFieldSubmitted: (v) {
                            loginPressed();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Forgot_Password(),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _screenHeight / (10 * 2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: loginPressed,
                              child: Text('Log In',
                                  style: TextStyle(color: Color(0xffFFFFFF))),
                              padding:
                                  EdgeInsets.fromLTRB(75.0, 13.0, 75.0, 13.0),
                              color: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don’t have an account?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Colors.amber,
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Account_Type(),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginPressed() async {
    FocusScope.of(context).unfocus();
    autoValidatePass = true;
    autoValidate = true;

    if (fromKey.currentState.validate()) {
      EasyLoading.show();
      _userController.checkLogin(controllerEmail.text, controllerPass.text);
      // var url = 'https://samojenterprises.in/api/users/signIn';
      // var body = json.encode({
      //   "username": controllerEmail.text.trim(),
      //   "password": controllerPass.text.trim()
      // });
      // var response = await http.post(Uri.parse(url),
      //     body: body, headers: {"Content-Type": "application/json"});
      // Map<String, dynamic> responseData = jsonDecode(response.body);
      // if (EasyLoading.isShow) EasyLoading.dismiss();
      // if (responseData != null) {
      //   if (responseData['statusCode'] == 200) {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => Dashboard()));
      //   }
      // }
    }
  }
}
