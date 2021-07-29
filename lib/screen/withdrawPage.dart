import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/helperclass/ClassMethod.dart';
import 'package:investing4you/models/Withdraw.dart';
import 'package:investing4you/models/WithdrawList.dart';

class WithdrawPage extends StatefulWidget {
  final id;
  final accountNo;
  const WithdrawPage({Key key, @required this.id, @required this.accountNo})
      : super(key: key);

  @override
  WithdrawPageState createState() => new WithdrawPageState();
}

class WithdrawPageState extends State<WithdrawPage> {
  var color;
  bool isLoading = true;
  List<WithdrawListData> withdrawList = [];
  TextEditingController _amountToDeposit = new TextEditingController();
  TextEditingController _comments = new TextEditingController();
  String sendAmount = "",
      accountId = "",
      comments = "",
      accountNo = "",
      statusId = "";
  @override
  void initState() {
    super.initState();
    accountId = widget.id.toString();
    accountNo = widget.accountNo.toString();
    withdrawList.clear();
    getWithdrawList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Withdraws',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 200,
            height: 50,
            padding: EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xFF38A0F4)),
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                        text: ' Add New ',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
              onPressed: () {
                newWithdraw();
              },
            ),
          ),
          Expanded(
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
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : refreshLayout(),
          ),
        ],
      ),
    );
  }

  newWithdraw() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      height: 50,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text(
                        'New Withdraw',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.only(left: 10, top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Text(
                                accountNo,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _amountToDeposit,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              maxLines: 5,
                              controller: _comments,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                focusedBorder: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                            ),
                            onPressed: () {
                              withdrawAmount();
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
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
                  ],
                ),
              ),
            ),
          );
        });
  }

  refreshLayout() {
    if (withdrawList.length == 0) {
      return Container(
        child: Center(
          child: Text('Nothing to show! Make a New Withdraw'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: withdrawList.length,
        shrinkWrap: false,
        physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, pos) => Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Card(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                    text: ' ACCOUNT ' +
                                        withdrawList[pos].accountNumber,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                    text: ' ' + withdrawList[pos].date,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: "Withdraw Amount:\t" + "£ ",
                              style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: withdrawList[pos].amount,
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: 'Comments:\n',
                              style: TextStyle(
                                  color: Color(0xFF707070),
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: "\t " + withdrawList[pos].comments,
                                    style: TextStyle(
                                      color: Color(0xFF959595),
                                    )),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    setText(withdrawList[pos].status),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  setText(status) {
    switch (status) {
      case 0:
        statusId = "Processing";
        color = Colors.orange;
        break;
      case 1:
        statusId = "Accepted";
        color = Colors.green;
        break;
      case 2:
        statusId = "Rejected";
        color = Colors.red;
    }
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
              text: 'Status: ',
              style: TextStyle(
                  color: Color(0xFF707070), fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: statusId,
                    style: TextStyle(
                      color: color,
                    )),
              ]),
        ),
      ),
    );
  }

  withdrawAmount() {
    sendAmount = _amountToDeposit.text.toString();
    comments = _comments.text.toString();
    if (_amountToDeposit.text.isEmpty) {
      toast('Please fill Amount');
    } else {
      Future<Withdraw> values =
          ApiService.amountWithdraw(accountId, sendAmount, comments);
      values.then((value) => {
            if (value.res == true)
              {
                _amountToDeposit.clear(),
                Navigator.pop(context),
                getWithdrawList(),
                withdrawList.clear(),
                refreshLayout(),
                toast(value.msg)
              }
            else
              {toast(value.msg)}
          });
    }
  }

  getWithdrawList() {
    Future<List<WithdrawListData>> values = ApiService.withdrawList(accountId);
    values.then((value) => {
          setState(() {
            isLoading = false;
          }),
          value.forEach((element) {
            setState(() {
              withdrawList.add(element);
            });
          })
        });
  }
}
