class Data {
  var id;
  var user_id;
  var account_id;
  String date;
  String account_number;
  String user;
  var amount;
  var status;
  String comments;

  Data(
      {this.id,
      this.user_id,
      this.account_id,
      this.date,
      this.account_number,
      this.user,
      this.amount,
      this.status,
      this.comments});

  factory Data.fromJson(dynamic json) {
    return Data(
      date: json['date'] as String ?? "",
      account_id: json['account_id'] ?? "",
      account_number: json['account_number'] as String ?? "",
      user_id: json['user_id'] ?? "",
      amount: json['amount'] ?? "",
      status: json['status'] ?? "",
      comments: json['comments'] as String ?? "",
      id: json['id'] ?? "",
    );
  }
}

class Withdraw {
  bool res;
  String msg;
  Data data;

  Withdraw({this.res, this.msg, this.data});

  factory Withdraw.fromJson(dynamic json) {
    return Withdraw(
      res: json['success'] as bool ?? false,
      msg: json['message'] as String ?? "",
      data: Data.fromJson(json['data']),
    );
  }
}
