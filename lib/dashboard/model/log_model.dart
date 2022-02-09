class LogModel {
  int createdInMonth, hour, minutes, maskCreated;
  DateTime loginTime;
  String loginTimeString;

  LogModel.fromJSON(Map<String, dynamic> json) {
    createdInMonth = json['createdInMonth'];
    hour = json['hour'];
    minutes = json['minutes'];
    maskCreated = json['maskCreated'];
    loginTimeString = json['loginTime'];
    if (loginTimeString != null) {
      loginTime = DateTime.tryParse(loginTimeString).toLocal();
    }
  }
}
