class data {
  int id;
  String first_name;
  String last_name;
  String number;
  String mailId;
  String address1;
  String address2;
  String city;
  String state;
  String country;
  String postcode;

  data(
      {this.id,
      this.first_name,
      this.last_name,
      this.number,
      this.mailId,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.postcode});

  factory data.fromJson(dynamic json) {
    return data(
      id: json['id'] as int ?? "",
      first_name: json['first_name'] as String ?? "",
      last_name: json['last_name'] as String ?? "",
      mailId: json['email'] as String ?? "",
      number: json['phone'] as String ?? "",
      address1: json['address_line'] as String ?? "",
      address2: json['address_line_extended'] as String ?? "",
      city: json['city'] as String ?? "",
      state: json['state'] as String ?? "",
      country: json['country'] as String ?? "",
      postcode: json['postcode'] as String ?? "",
    );
  }
}

class Account {
  bool res;
  String msg;
  data datas;

  Account({this.res, this.msg, this.datas});

  factory Account.fromJson(dynamic json) {
    return Account(
      res: json['success'] as bool ?? false,
      msg: json['message'] as String ?? "",
      datas: data.fromJson(json['data']),
    );
  }
}
