import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:investing4you/models/Dashboard.dart';
import 'package:investing4you/screen/notificationPage.dart';
import 'package:investing4you/screen/transactionPage.dart';
import 'package:investing4you/screen/withdrawPage.dart';
import 'package:package_info/package_info.dart';

import 'depositPage.dart';
import 'main.dart';

class DashboardPage extends StatefulWidget {
  @override
  DashboardPageState createState() => new DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  List<DashboardData> dashboard = [];
  bool setVisible = true, isLoading = true;
  String version, username = '';
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    dashboard.clear();
    getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    username = SharedPrefs.firstname + " " + SharedPrefs.lastname;
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'DashBoard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        brightness: Brightness.dark,
      ),
      body: WillPopScope(
        onWillPop: onwillpop,
        child: Container(
          color: Colors.black,
          child: isLoading
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 100),
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
              : dashboardPage(),
        ),
      ),
    );
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

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  getDashboard() {
    Future<List<DashboardData>> values = ApiService.dashboard();
    values.then((value) => {
          setState(() {
            isLoading = false;
          }),
          value.forEach((element) {
            setState(() {
              dashboard.add(element);
            });
          })
        });
  }

  getData() {
    SharedPrefs.balance(dashboard[0].amount);
    return Text(dashboard[0].amount);
  }

  dashboardPage() {
    if (dashboard.length != 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hello' + " " + username + '!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Here's your account balance",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dashboard.length,
                  shrinkWrap: false,
                  physics:
                      ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, pos) => Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8.0),
                                      child: Text(
                                        'ACCOUNT' +
                                            " " +
                                            dashboard[pos].accountNumber,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Current Balance',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text('£ ' + dashboard[pos].amount,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black54),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.account_balance_wallet,
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Deposit',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DepositPage(
                                                        id: dashboard[pos]
                                                            .accountId,
                                                        accountNo: dashboard[
                                                                pos]
                                                            .accountNumber)));
                                      },
                                    ),
                                    InkWell(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black54),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.credit_card,
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Withdraw',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WithdrawPage(
                                                        id: dashboard[pos]
                                                            .accountId,
                                                        accountNo: dashboard[
                                                                pos]
                                                            .accountNumber)));
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationPage(
                                                        id: dashboard[pos]
                                                            .accountId)));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black54),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.notifications,
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Notification',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionPage(
                                                        id: dashboard[pos]
                                                            .accountId,
                                                        accountNo:
                                                            dashboard[pos]
                                                                .accountNumber,
                                                        balance: dashboard[pos]
                                                            .amount)));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.black54),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.history,
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'Transactions',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: false,
                                  child: getData(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      toast("No account found this profile");
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hello' + " " + username + '!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Here's your account balance",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
