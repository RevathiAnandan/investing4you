class Data {
  String token;
  String first_name;
  String last_name;
  String is_active;

  Data({this.token, this.first_name, this.last_name, this.is_active});

  factory Data.fromJson(dynamic json) {
    return Data(
      token: json['token'] as String ?? "",
      first_name: json['first_name'] as String ?? "",
      last_name: json['last_name'] as String ?? "",
      is_active: json['is_active'] as String ?? "",
    );
  }
}

class UserDetails {
  bool res;
  String msg;
  Data data;

  UserDetails({this.res, this.msg, this.data});

  factory UserDetails.fromJson(dynamic json) {
    return UserDetails(
      res: json['success'] as bool ?? false,
      msg: json['message'] as String ?? "",
      data: Data.fromJson(json['data']),
    );
  }
}
