class WithdrawListData {
  var id;
  String date;
  String accountNumber;
  String user;
  var amount;
  var status;
  String comments;

  WithdrawListData(
      {this.id,
      this.date,
      this.accountNumber,
      this.user,
      this.amount,
      this.status,
      this.comments});

  factory WithdrawListData.fromJson(dynamic json) {
    return WithdrawListData(
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

class WithdrawList {
  List<WithdrawListData> data;

  WithdrawList({this.data});

  factory WithdrawList.fromJson(dynamic json) {
    var tagObjJson = json['data'] as List ?? [];
    List<WithdrawListData> data = tagObjJson
        .map((tagJson) => WithdrawListData.fromJson(tagJson))
        .toList();
    return new WithdrawList(
      data: data,
    );
  }
}
