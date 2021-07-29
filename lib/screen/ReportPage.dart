import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';

import 'ReportDetailsPage.dart';
import 'main.dart';

class ReportPage extends StatefulWidget {
  @override
  ReportPageState createState() => new ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        title: Text('Reports'),
      ),
      body: WillPopScope(
        onWillPop: onwillpop,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: Icon(
                      Icons.receipt_long,
                      size: 20,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Reports',
                      style: TextStyle(color: Colors.blue),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                    children: [
                      Divider(
                        color: Colors.black,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Deposit Reports',
                            style: TextStyle(color: Colors.blue),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReportDetailsPage(
                                    id: 3, title: 'Deposit Reports')));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10.0, top: 1.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Withdraw Reports',
                            style: TextStyle(color: Colors.blue),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: 20,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReportDetailsPage(
                                    id: 4, title: 'Withdraw Reports')));
                          },
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
}
