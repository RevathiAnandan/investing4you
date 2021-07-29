class ReportReceiptData {
  var id;
  String date;
  String user;
  var amount;
  String status;
  String comments;
  var roleId;

  ReportReceiptData(
      {this.id,
      this.date,
      this.user,
      this.amount,
      this.status,
      this.comments,
      this.roleId});

  factory ReportReceiptData.fromJson(dynamic json) {
    return ReportReceiptData(
      id: json['id'] ?? "",
      date: json['date'] as String ?? "",
      user: json['user'] as String ?? "",
      amount: json['amount'] as String ?? "",
      status: json['status'] ?? "",
      comments: json['comments'] as String ?? "",
      roleId: json['role_id'] ?? "",
    );
  }
}

class ReportReceipt {
  List<ReportReceiptData> data;

  ReportReceipt({this.data});

  factory ReportReceipt.fromJson(dynamic json) {
    var tagObjJson = json['data'] as List ?? [];
    List<ReportReceiptData> data = tagObjJson
        .map((tagJson) => ReportReceiptData.fromJson(tagJson))
        .toList();
    return new ReportReceipt(
      data: data,
    );
  }
}
