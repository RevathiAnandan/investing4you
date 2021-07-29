import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investing4you/screen/accountPage.dart';

import 'ReceiptPage.dart';
import 'ReportPage.dart';
import 'dashboardPage.dart';

DateTime currentbackpressed;

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  ListQueue<int> _navigationQueue = ListQueue();
  int _currentIndex = 0;
  var _children = [
    DashboardPage(),
    ReportPage(),
    ReceiptPage(),
    AccountPage(),
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      extendBody: true,
      body: WillPopScope(
        onWillPop: onwillpop,
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            fixedColor: Theme.of(context).accentColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            currentIndex: _currentIndex,
            onTap: onTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'DashBoard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Report',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.receipt), label: 'Receipt'),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onwillpop() async {
    if (_navigationQueue.isEmpty) return true;
    setState(() {
      _navigationQueue.removeLast();
      int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
      _currentIndex = position;
    });
    return false;
  }
}
