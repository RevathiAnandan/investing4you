import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _prefs;
  static initialize() async {
    if (_prefs != null) {
      return _prefs;
    } else {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<void> login() async {
    return _prefs.setBool('login', true);
  }

  static Future<void> saveDeviceID(String deviceID) async {
    return _prefs.setString('deviceID', deviceID);
  }

  static Future<void> saveID(String loginId) async {
    return _prefs.setString('loginId', loginId);
  }

  static Future<void> userId(String userId) async {
    return _prefs.setString('userId', userId);
  }

  static Future<void> startname(String firstname) async {
    return _prefs.setString('firstname', firstname);
  }

  static Future<void> endname(String lastname) async {
    return _prefs.setString('lastname', lastname);
  }

  static Future<void> tokenKey(String token) async {
    return _prefs.setString('token', token);
  }

  static Future<void> balance(String balance) async {
    return _prefs.setString('balance', balance);
  }

  static Future<void> sharedClear() async {
    return _prefs.clear();
  }

  static Future<void> sharedRemove(String key) async {
    return _prefs.remove(key);
  }

  static bool get getLogin => _prefs.getBool('login') ?? false;
  static String get LoginId => _prefs.getString('loginId') ?? "";
  static String get getDeviceID => _prefs.getString('deviceID') ?? '';
  static String get UserId => _prefs.getString('userId') ?? "";
  static String get token => _prefs.getString('token') ?? "";
  static String get firstname => _prefs.getString('firstname') ?? "";
  static String get lastname => _prefs.getString('lastname') ?? "";
  static String get balanceAmount => _prefs.getString('balance') ?? "";
}
