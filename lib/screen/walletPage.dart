import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';

import 'main.dart';

class WalletPage extends StatefulWidget {
  @override
  WalletPageState createState() => new WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: Text(
          'Wallet',
          style: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
      ),
      body: WillPopScope(
        onWillPop: onwillpop,
        child: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: ' Wallet Balance ',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      WidgetSpan(
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 220,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.black,
                            Colors.blue,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(' Wallet ',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 10, bottom: 5),
                                child: Icon(
                                  Icons.credit_card,
                                  color: Colors.white60,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 10),
                                child: Text(
                                    SharedPrefs.firstname +
                                        SharedPrefs.lastname,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 5,
                                ),
                                child: Text('£ ' + SharedPrefs.balanceAmount,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
