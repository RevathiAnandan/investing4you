import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/models/ReportReceipt.dart';

class ReportDetailsPage extends StatefulWidget {
  final id;
  final String title;

  const ReportDetailsPage({Key key, @required this.id, @required this.title})
      : super(key: key);

  @override
  ReportDetailsPageState createState() => ReportDetailsPageState();
}

class ReportDetailsPageState extends State<ReportDetailsPage> {
  var color;
  bool isLoading = true, setVisible = true;
  String id = "",
      title = "",
      balance = "",
      fromDate = "",
      toDate = "",
      formatsDate = "";
  List<ReportReceiptData> reportReceipt = [];
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
    id = widget.id.toString();
    title = widget.title.toString();
    dateFormat(currentDate);
    fromDate = formatsDate;
    toDate = formatsDate;
    reportReceipt.clear();
    getReportReceipt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: false,
            child: Container(
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
                    onPressed: () {},
                  ),
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
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : getReports(),
          ),
        ],
      ),
    );
  }

  dateFormat(DateTime date) {
    setState(() {
      formatsDate = formatDate(date, [dd, '-', mm, '-', yyyy]);
    });
  }

  getReports() {
    if (reportReceipt.length == 0) {
      return Container(
        child: Center(
          child: Text('No data available!'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: reportReceipt.length,
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
                                text: reportReceipt[pos].date,
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
                                text: 'User: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' ' + reportReceipt[pos].user,
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
                            text: 'Amount: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: ' ' + reportReceipt[pos].amount,
                                  style: TextStyle(
                                    color: Color(0xFF959595),
                                  )),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: setVisible,
                      child: Column(
                        children: [
                          setText(reportReceipt[pos].status),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: RichText(
                        text: TextSpan(
                            text: 'Comments: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: ' ' + reportReceipt[pos].comments,
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
      );
    }
  }

  getReportReceipt() {
    Future<List<ReportReceiptData>> values;
    if (id == "1") {
      setVisible = false;
      values = ApiService.reportReceipt("receipts/deposits");
    } else if (id == "2") {
      setVisible = false;
      values = ApiService.reportReceipt("receipts/withdraws");
    } else if (id == "3") {
      values = ApiService.reportReceipt("reports/deposits");
    } else if (id == "4") {
      values = ApiService.reportReceipt("reports/withdraws");
    }
    values.then((value) => {
          setState(() {
            isLoading = false;
          }),
          value.forEach((element) {
            setState(() {
              reportReceipt.add(element);
            });
          })
        });
  }

  setText(String status) {
    switch (status) {
      case "Processing":
        color = Colors.orange;
        break;
      case "Accepted":
        color = Colors.green;
        break;
      case "Rejected":
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
                    text: status,
                    style: TextStyle(
                      color: color,
                    )),
              ]),
        ),
      ),
    );
  }
}
