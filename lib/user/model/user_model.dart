class User {
  String id, token, name, role, companyName, itemname, itemType;

  User();

  User.fromJSON(Map<String, dynamic> map) {
    token = map['apiKey'];
    name = map['user'];
    role = map['role'];
    companyName = map['companyName'];
    itemname = map['itemname'];
    itemType = map['itemType'];
  }

  toJSON() {
    return {
      'apiKey': token,
      'user': name,
      'role': role,
      'companyName': companyName,
      'itemname': itemname,
      'itemType': itemType
    };
  }
}
