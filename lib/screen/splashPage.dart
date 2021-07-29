import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:package_info/package_info.dart';

import 'loginPage.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  _doNavigation() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (SharedPrefs.getLogin) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => Main()));
      } else {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _doNavigation();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/logo.png',
                  height: 300, alignment: Alignment.center),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Version :" + _packageInfo.version,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
