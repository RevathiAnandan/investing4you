import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/models/Password.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  bool _isHidden = true, _isHidden1 = true, _isHidden2 = true, res = false;
  TextEditingController _password = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Container(
                      width: 500,
                      height: 200,
                      child: Image.asset('assets/images/logo.png')),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      obscureText: _isHidden,
                      controller: _password,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                        ),
                        labelText: 'Old Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
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
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: _isHidden1,
                      controller: _newPassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                        ),
                        labelText: 'New Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView1,
                          child: Icon(
                            _isHidden1
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
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: _isHidden2,
                      controller: _confirmPassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white),
                        ),
                        labelText: 'Confirm New Password',
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView2,
                          child: Icon(
                            _isHidden2
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF38A0F4)),
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    changePassword();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      _isHidden2 = !_isHidden2;
    });
  }

  changePassword() {
    String password = _password.text.toString();
    String newPassword = _newPassword.text.toString();
    String confirmPassword = _confirmPassword.text.toString();
    if (_password.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      toast('Please Fills All Details');
    } else {
      Future<Password> values =
          ApiService.changePassword(password, newPassword, confirmPassword);
      values.then((value) => {
            if (value.res == true)
              {
                res = value.res,
                toast(value.msg),
              }
            else
              {
                toast(value.msg),
              }
          });
      _password.clear();
      _newPassword.clear();
      _confirmPassword.clear();
    }
  }
}
