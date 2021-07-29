import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/models/PaymentMessage.dart';
import 'package:investing4you/screen/main.dart';
/*import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/models/Deposit.dart';*/
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String initialUrl;
  const PaymentScreen({
    Key key,
    @required this.initialUrl,
  }) : super(key: key);
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String initialUrl = '',
      paymentUrl = '',
      paymentMessage = '',
      paymentData = '',
      paymentImage = '';
  bool isLoading = false;
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    initialUrl = widget.initialUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
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
                      'Fetching your Payment Details! please Wait...',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _webViewController.loadUrl(initialUrl);
              },
              onWebResourceError: (error) {
                // print(error.toString());
                toast('Something went wrong!');
              },
              onPageFinished: (page) {
                // print(page.toString());
                if (page.contains("api/paymenterror")) {
                  setState(() {
                    isLoading = true;
                  });
                  paymentUrl = page.toString();
                  Future<PaymentMessage> values =
                      ApiService.paymentMessage(paymentUrl);
                  values.then((value) => {
                        if (value.success == true)
                          {
                            paymentData = value.data,
                            paymentMessage = value.message,
                            if (paymentData == "failure")
                              {
                                paymentImage = 'assets/images/cancel.png',
                              },
                            getData(),
                          }
                        else
                          {
                            paymentData = "Error",
                          }
                      });
                } else if (page.contains("investing4u/api/paymentsuccess")) {
                  setState(() {
                    isLoading = true;
                  });
                  paymentUrl = page.toString();
                  Future<PaymentMessage> values =
                      ApiService.paymentMessage(paymentUrl);
                  values.then((value) => {
                        if (value.success == true)
                          {
                            paymentData = value.data,
                            paymentMessage = value.message,
                            if (paymentData == "success")
                              {
                                paymentImage = 'assets/images/success.png',
                              },
                            getData(),
                          }
                        else
                          {
                            paymentData = "Error",
                          }
                      });
                }
              },
            ),
    );
  }

  getData() {
    if (paymentData == "Error") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                height: 250,
                child: Column(
                  children: [
                    Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Something went wrong!"),
                  ],
                ),
              ),
            );
          });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                height: 250,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(paymentImage),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(paymentMessage),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        child: Text(
                          'Go to Back',
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Main()),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}
