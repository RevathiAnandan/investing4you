class TransactionList {
  var id;
  String date;
  String deposit;
  String withdraw;
  String percentage;
  String profit;
  String commission;
  String balance;

  TransactionList(
      {this.id,
      this.date,
      this.deposit,
      this.withdraw,
      this.percentage,
      this.profit,
      this.commission,
      this.balance});

  factory TransactionList.fromJson(dynamic json) {
    return TransactionList(
      id: json['id'] ?? "",
      date: json['date'] as String ?? "",
      deposit: json['deposit'] as String ?? "",
      withdraw: json['withdraw'] as String ?? "",
      percentage: json['percentage'] as String ?? "",
      profit: json['profit'] as String ?? "",
      commission: json['commission'] as String ?? "",
      balance: json['balance'] as String ?? "",
    );
  }
}

class Transaction {
  List<TransactionList> data;

  Transaction({this.data});

  factory Transaction.fromJson(dynamic json) {
    var tagObjJson = json['data'] as List ?? [];
    List<TransactionList> data =
        tagObjJson.map((tagJson) => TransactionList.fromJson(tagJson)).toList();
    return new Transaction(
      data: data,
    );
  }
}
