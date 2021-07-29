import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:investing4you/models/Account.dart';
import 'package:investing4you/models/Dashboard.dart';
import 'package:investing4you/models/Deposit.dart';
import 'package:investing4you/models/DepositList.dart';
import 'package:investing4you/models/Notification.dart';
import 'package:investing4you/models/Password.dart';
import 'package:investing4you/models/PaymentMessage.dart';
import 'package:investing4you/models/ReportReceipt.dart';
import 'package:investing4you/models/Transaction.dart';
import 'package:investing4you/models/UserDetails.dart';
import 'package:investing4you/models/Withdraw.dart';
import 'package:investing4you/models/WithdrawList.dart';

import 'ApiConnection.dart';

class ApiService {
  static String token = SharedPrefs.token;
  static String deviceToken = SharedPrefs.getDeviceID;

  static Future<UserDetails> doLogin(String validEmail, String passWord) async {
    // print(deviceId);
    final response = await https.post(
        Uri.https(ApiConnection.BASE_URL, ApiConnection.ApiPath + "login"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": validEmail,
          "password": passWord,
          "device_token": deviceToken
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      UserDetails values = UserDetails.fromJson(user);
      return values;
    } else {
      Map<String, dynamic> user = json.decode(response.body);
      UserDetails values = UserDetails.fromJson(user);
      return values;
    }
  }

  static Future<Password> changePassword(
      String password, String newpassword, String confirmpassword) async {
    final response = await https.post(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "password/" + SharedPrefs.UserId),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "current_password": password,
          "password": newpassword,
          "password_confirmation": confirmpassword
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      Password values = Password.fromJson(user);
      return values;
    } else {
      Map<String, dynamic> user = json.decode(response.body);
      Password values = Password.fromJson(user);
      return values;
    }
  }

  static Future<Account> account() async {
    final response = await https.get(
        Uri.https(ApiConnection.BASE_URL, ApiConnection.ApiPath + "account"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      Account values = Account.fromJson(user);
      return values;
    } else {
      Map<String, dynamic> user = json.decode(response.body);
      Account values = Account.fromJson(user);
      return values;
    }
  }

  static Future<List<DashboardData>> dashboard() async {
    final response = await https.get(
        Uri.https(ApiConnection.BASE_URL, ApiConnection.ApiPath + "dashboard"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        Dashboard values = Dashboard.fromJson(user);
        return values.data;
      } else {
        return null;
      }
    }
  }

  static Future<Account> updateAccount(
      String fullName,
      String lastName,
      String number,
      String address1,
      String address2,
      String city,
      String state,
      String country,
      String postcode) async {
    final response = await https.post(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "account/" + SharedPrefs.UserId),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: ({
          "first_name": fullName,
          "last_name": lastName,
          "phone": number,
          "address_line": address1,
          "address_line_extended": address2,
          "city": city,
          "state": state,
          "country": country,
          "postcode": postcode
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      Account values = Account.fromJson(user);
      return values;
    } else {
      Map<String, dynamic> user = json.decode(response.body);
      Account values = Account.fromJson(user);
      return values;
    }
  }

  static Future<List<TransactionList>> transactions(
      String id, String fromDate, String toDate) async {
    var queryParameters = {"fromDate": fromDate, "toDate": toDate};
    final response = await https.get(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "transactions/" + id, queryParameters),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        Transaction values = Transaction.fromJson(user);
        return values.data;
      } else {
        return null;
      }
    }
  }

  static Future<List<DepositListData>> depositList(String id) async {
    final response = await https.get(
        Uri.https(
            ApiConnection.BASE_URL, ApiConnection.ApiPath + "deposits/" + id),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        DepositList values = DepositList.fromJson(user);
        return values.data;
      } else {
        return null;
      }
    }
  }

  static Future<List<WithdrawListData>> withdrawList(String id) async {
    final response = await https.get(
        Uri.https(
            ApiConnection.BASE_URL, ApiConnection.ApiPath + "withdraws/" + id),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        WithdrawList values = WithdrawList.fromJson(user);
        return values.data;
      } else {
        return null;
      }
    }
  }

  static Future<List<LinksURL>> amountDeposit(
      String id, String amount, String comment) async {
    final response = await https.post(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "deposits/create/" + id),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "amount": amount,
          "comments": comment
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      String id = user['id'];
      if (id != null) {
        Deposit values = Deposit.fromJson(user);
        return values.links;
      } else {
        return null;
      }
    }
  }

  static Future<Withdraw> amountWithdraw(
      String id, String amount, String comment) async {
    final response = await https.post(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "withdraws/create/" + id),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "amount": amount,
          "comments": comment
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      Withdraw values = Withdraw.fromJson(user);
      return values;
    } else {
      Map<String, dynamic> user = json.decode(response.body);
      Withdraw values = Withdraw.fromJson(user);
      return values;
    }
  }

  static Future<List<ReportReceiptData>> reportReceipt(String apiName) async {
    final response = await https.get(
        Uri.https(ApiConnection.BASE_URL, ApiConnection.ApiPath + apiName),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        ReportReceipt values = ReportReceipt.fromJson(user);
        return values.data;
      } else {
        return null;
      }
    }
  }

  static Future<PaymentMessage> paymentMessage(String url) async {
    // print(url);
    final response = await https.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      // print(response.body.toString());
      Map<String, dynamic> user = json.decode(response.body);
      PaymentMessage values = PaymentMessage.fromJson(user);
      return values;
    } else {
      // print(response.body.toString());
      Map<String, dynamic> user = json.decode(response.body);
      PaymentMessage values = PaymentMessage.fromJson(user);
      return values;
    }
  }

  static Future<NotificationList> notification(String id) async {
    final response = await https.get(
        Uri.https(ApiConnection.BASE_URL,
            ApiConnection.ApiPath + "notifications/" + id),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> user = json.decode(response.body);
      bool res = user['success'];
      if (res == true) {
        NotificationList values = NotificationList.fromJson(user);
        return values;
      } else {
        return null;
      }
    }
  }
}
