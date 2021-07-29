class Password {
  bool res;
  String msg;
  String data;

  Password({this.res, this.msg, this.data});

  factory Password.fromJson(dynamic json) {
    return Password(
      res: json['success'] as bool ?? false,
      msg: json['message'] as String ?? "",
      data: json['message'] as String ?? "",
    );
  }
}
