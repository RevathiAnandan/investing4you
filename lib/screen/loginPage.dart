import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:investing4you/models/UserDetails.dart';
import 'package:local_auth/local_auth.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  bool isAuthenticating = false;
  String _authorized = 'Not Authorized';
  var validEmail;
  String deviceId = '';
  String passWord, authVerify = "";
  bool _isHidden = true, isLoading = false;
  TextEditingController _emailId = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // SharedPrefs.sharedClear();
    getdeviceId();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      // print(e);
    }
    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      // print(e);
    }
    if (!mounted) return;

    setState(() {
      availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    bool authenticated = false;
    try {
      setState(() {
        isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      // print(e);
      setState(() {
        isAuthenticating = false;
        _authorized = "Error - ${e.message}";
        toast(e.message);
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      if (_authorized == 'Not Authorized') {
        authVerify = '0';
      } else {
        authVerify = '1';
      }
      authLocal(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 100),
                  height: 200,
                  child: Image.asset('assets/images/logo.png')),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.perm_identity_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        controller: _emailId,
                        decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                          labelText: 'E-Mail Address',
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: TextField(
                        obscureText: _isHidden,
                        controller: _password,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                          labelText: 'Password',
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: false,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                  child: InkWell(
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: isLoading
                    ? Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF38A0F4)),
                        child: Text(
                          'LogIn',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        onPressed: () {
                          loginPressed();
                        },
                      ),
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '(Or)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Container(
                  margin: EdgeInsets.only(left: 8.0, right: 20.0, bottom: 10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.fingerprint,
                      color: Colors.blue,
                      size: 50,
                    ),
                    onPressed: () {
                      fingerAuth(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginPressed() {
    validEmail = _emailId.text;
    passWord = _password.text.toString();
    if (_emailId.text.isEmpty || _password.text.isEmpty) {
      toast('Please Fills All Details');
    } else if (!EmailValidator.validate(validEmail)) {
      toast('Please enter valid email address');
    } else {
      setState(() {
        isLoading = true;
      });
      Future<UserDetails> values =
          ApiService.doLogin(validEmail, passWord /*, deviceId*/);
      values.then((value) => {
            if (value.res == true)
              {
                SharedPrefs.saveID(value.data.is_active),
                SharedPrefs.login(),
                SharedPrefs.startname(value.data.first_name),
                SharedPrefs.endname(value.data.last_name),
                SharedPrefs.tokenKey(value.data.token),
                toast(value.msg),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Main()),
                    (Route<dynamic> route) => false),
              }
            else
              {
                setState(() {
                  isLoading = false;
                }),
                toast(value.msg),
              }
          });
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void fingerAuth(BuildContext context) {
    if (_supportState == _SupportState.unknown) {
      // print("This device is unknown State");
    } else if (_supportState == _SupportState.supported) {
      // print("This device is supported");
      _checkBiometrics();
      _getAvailableBiometrics();
      _authenticateWithBiometrics(context);
    } else {
      // print("This device is not supported");
      toast('This device is not supported');
    }
  }

  void authLocal(BuildContext context) {
    if (authVerify == '0') {
      toast('Unauthorized');
    } else {
      toast('Authorized');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Main()),
          (Route<dynamic> route) => false);
    }
  }

  getdeviceId() async {
    deviceId = await PlatformDeviceId.getDeviceId;
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
