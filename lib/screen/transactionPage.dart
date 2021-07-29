import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/models/Transaction.dart';

class TransactionPage extends StatefulWidget {
  final id;
  final String accountNo, balance;
  const TransactionPage(
      {Key key, this.id, @required this.accountNo, @required this.balance})
      : super(key: key);
  @override
  TransactionPageState createState() => new TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  bool isLoading = true;
  String accountId = "",
      accountNo = "",
      balance = "",
      fromDate = "",
      toDate = "",
      formatsDate = "";
  List<TransactionList> transactionList = [];
  DateTime currentDate = DateTime.now();
  DateTime currentDate2 = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != currentDate)
      setState(() {
        currentDate = picked;
        DateTime newDate = currentDate.toLocal();
        dateFormat(newDate);
        fromDate = formatsDate;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: currentDate2,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != currentDate2)
      setState(() {
        currentDate2 = picked;
        DateTime newDate = currentDate2.toLocal();
        dateFormat(newDate);
        toDate = formatsDate;
      });
  }

  @override
  void initState() {
    super.initState();
    accountId = widget.id.toString();
    accountNo = widget.accountNo.toString();
    balance = widget.balance.toString();
    transactionList.clear();
    dateFormat(currentDate);
    fromDate = formatsDate;
    toDate = formatsDate;
    getTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          'Current account - ' + accountNo,
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Material(
            color: Colors.black,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '£ ' + balance + '\n',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      TextSpan(
                          text: 'Account Balance',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF38A0F4)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'From:',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        TextSpan(
                            text: fromDate,
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF38A0F4)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'To: ',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        TextSpan(
                            text: toDate,
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    _selectDate2(context);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF38A0F4)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Apply',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    transactionList.clear();
                    getTransactionList();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 10.0, top: 10.0, right: 20.0, bottom: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Account balance: ',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextSpan(
                      text: '£ ' + balance,
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
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
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : getTransaction(),
          ),
        ],
      ),
    );
  }

  allTransaction(int pos) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                child: Column(
                  children: [
                    TitledContainer(
                      title: 'Date',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].date,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Deposit(£)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].deposit,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Withdraw(£)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].withdraw,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Profit(£)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].profit,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Profit(%)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].percentage,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Commission(£)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].commission,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TitledContainer(
                      title: 'Closing balance(£)',
                      fontSize: 16.0,
                      titleColor: Colors.black,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(transactionList[pos].balance,
                              style: TextStyle(fontSize: 12.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  getTransaction() {
    if (transactionList.length == 0) {
      return Container(
        child: Center(
          child: Text('Today no transaction for this account number'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: transactionList.length,
        shrinkWrap: false,
        physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, pos) => Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: InkWell(
            onTap: () {
              allTransaction(pos);
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Date: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: transactionList[pos].date,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Deposit: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ' + transactionList[pos].deposit,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: 'Withdraw: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: ' ' + transactionList[pos].withdraw,
                                    style: TextStyle(
                                      color: Color(0xFF959595),
                                    )),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              text: 'Closing balance: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: ' ' + transactionList[pos].balance,
                                    style: TextStyle(
                                      color: Color(0xFF959595),
                                    )),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  getTransactionList() {
    Future<List<TransactionList>> values =
        ApiService.transactions(accountId, fromDate, toDate);
    values.then((value) => {
          setState(() {
            isLoading = false;
          }),
          value.forEach((element) {
            setState(() {
              transactionList.add(element);
            });
          })
        });
  }

  dateFormat(DateTime date) {
    setState(() {
      formatsDate = formatDate(date, [dd, '-', mm, '-', yyyy]);
    });
  }
}
