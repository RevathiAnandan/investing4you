class DashboardData {
  var id;
  var userId;
  var accountId;
  String amount;
  var status;
  String createdAt;
  String accountNumber;

  DashboardData(
      {this.id,
      this.userId,
      this.accountId,
      this.amount,
      this.status,
      this.createdAt,
      this.accountNumber});

  factory DashboardData.fromJson(dynamic json) {
    return DashboardData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      accountId: json['account_id'] ?? 0,
      amount: json['amount'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? 0,
      accountNumber: json['account_number'] ?? 0,
    );
  }
}

class Dashboard {
  List<DashboardData> data;

  Dashboard({this.data});

  factory Dashboard.fromJson(dynamic json) {
    var tagObjJson = json['data'] as List ?? [];
    List<DashboardData> datas =
        tagObjJson.map((tagJson) => DashboardData.fromJson(tagJson)).toList();
    return new Dashboard(
      data: datas,
    );
  }
}
