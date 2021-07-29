import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:investing4you/models/Account.dart';
import 'package:investing4you/screen/changePassword.dart';
import 'package:investing4you/screen/loginPage.dart';

import 'main.dart';

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => new AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _mailId = new TextEditingController();
  TextEditingController _adsLine1 = new TextEditingController();
  TextEditingController _adsLine2 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  TextEditingController _postcode = new TextEditingController();
  bool isLoading = true;
  var _value;
  String fullName = "",
      lastName = "",
      number = "",
      address1 = "",
      address2 = "",
      city = "",
      state = "",
      country = "",
      postcode = "";

  @override
  void initState() {
    clearData();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Account Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
              elevation: 20,
              enabled: true,
              onSelected: (value) {
                setState(() {
                  _value = value;
                  onTapped(_value);
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.password,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                                text: '   Password',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                                text: '   Logout',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                      value: 2,
                    )
                  ])
        ],
      ),
      body: WillPopScope(
        onWillPop: onwillpop,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            color: Colors.black,
            child: isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 100),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Fetching your Details! please Wait...',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: TextField(
                            controller: _firstname,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'First Name',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _lastname,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Last Name',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Phone NUmber',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _mailId,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Email Address',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _adsLine1,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Address Line1',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _adsLine2,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Address Line2',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: new BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: _city,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelText: 'City',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: _state,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelText: 'State',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: _country,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelText: 'Country',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: _postcode,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelText: 'Postcode',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    borderSide:
                                        new BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.white),
                                ),
                                onPressed: () {
                                  getUpdateData();
                                  updateData();
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  clearData() {
    _firstname.clear();
    _lastname.clear();
    _number.clear();
    _mailId.clear();
    _adsLine1.clear();
    _adsLine2.clear();
    _city.clear();
    _state.clear();
    _country.clear();
    _postcode.clear();
  }

  loadData() {
    Future<Account> values = ApiService.account();
    values.then((value) => {
          if (value.res == true)
            {
              setState(() {
                isLoading = false;
              }),
              toast(value.msg),
              SharedPrefs.userId(value.datas.id.toString()),
              _firstname.text = value.datas.first_name,
              _lastname.text = value.datas.last_name,
              _number.text = value.datas.number,
              _mailId.text = value.datas.mailId,
              _adsLine1.text = value.datas.address1,
              _adsLine2.text = value.datas.address2,
              _city.text = value.datas.city,
              _state.text = value.datas.state,
              _country.text = value.datas.country,
              _postcode.text = value.datas.postcode,
            }
          else
            {
              toast(value.msg),
            }
        });
  }

  updateData() {
    Future<Account> values = ApiService.updateAccount(fullName, lastName,
        number, address1, address2, city, state, country, postcode);
    values.then((value) => {
          if (value.res == true)
            {
              clearData(),
              toast(value.msg),
              SharedPrefs.userId(value.datas.id.toString()),
              _firstname.text = value.datas.first_name,
              _lastname.text = value.datas.last_name,
              _number.text = value.datas.number,
              _mailId.text = value.datas.mailId,
              _adsLine1.text = value.datas.address1,
              _adsLine2.text = value.datas.address2,
              _city.text = value.datas.city,
              _state.text = value.datas.state,
              _country.text = value.datas.country,
              _postcode.text = value.datas.postcode,
            }
          else
            {
              toast(value.msg),
            }
        });
  }

  getUpdateData() {
    fullName = _firstname.text.toString();
    lastName = _lastname.text.toString();
    number = _number.text.toString();
    address1 = _adsLine1.text.toString();
    address2 = _adsLine2.text.toString();
    city = _city.text.toString();
    state = _state.text.toString();
    country = _country.text.toString();
    postcode = _postcode.text.toString();
  }

  onTapped(var _value) {
    switch (_value) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChangePassword()));
        break;
      case 2:
        SharedPrefs.sharedClear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
    }
  }

  Future<bool> onwillpop() {
    DateTime now = DateTime.now();
    if (currentbackpressed == null ||
        now.difference(currentbackpressed) > Duration(seconds: 2)) {
      currentbackpressed = now;
      toast('Double tap to exit the app');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
