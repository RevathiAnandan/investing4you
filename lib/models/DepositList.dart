class DepositListData {
  var id;
  String date;
  String accountNumber;
  String user;
  var amount;
  var status;
  String comments;

  DepositListData(
      {this.id,
      this.date,
      this.accountNumber,
      this.user,
      this.amount,
      this.status,
      this.comments});

  factory DepositListData.fromJson(dynamic json) {
    return DepositListData(
      id: json['id'] ?? "",
      date: json['date'] as String ?? "",
      accountNumber: json['account_number'] as String ?? "",
      user: json['user'] as String ?? "",
      amount: json['amount'] as String ?? "",
      status: json['status'] ?? "",
      comments: json['comments'] as String ?? "",
    );
  }
}

class DepositList {
  List<DepositListData> data;

  DepositList({this.data});

  factory DepositList.fromJson(dynamic json) {
    var tagObjJson = json['data'] as List ?? [];
    List<DepositListData> data =
        tagObjJson.map((tagJson) => DepositListData.fromJson(tagJson)).toList();
    return new DepositList(
      data: data,
    );
  }
}
