import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:investing4you/apiservice/ApiService.dart';
import 'package:investing4you/models/Notification.dart';

class NotificationPage extends StatefulWidget {
  final id;
  const NotificationPage({Key key, @required this.id}) : super(key: key);

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  List<bool> selected;
  List<Datum> notificationData = [];
  List<dynamic> title = [];
  List<dynamic> description = [];
  String titles, descriptions, accountId;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    accountId = widget.id;
    getNotification();
    // selected = List.filled(count, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title: Text(
          'Notification',
          style: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
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
          : notificatoinPage(),
    );
  }

  getNotification() {
    Future<NotificationList> values = ApiService.notification(accountId);
    values.then((value) {
      setState(() {
        isLoading = false;
      });
      value.data.forEach((element) {
        notificationData.add(element);
      });
    });
  }

  notificatoinPage() {
    if (notificationData.length == 0) {
      return Container(
        child: Center(
          child: Text('No Notification'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: notificationData.length,
        shrinkWrap: false,
        physics: ScrollPhysics(),
        itemBuilder: (context, pos) => Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
          child: Card(
            elevation: 2.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              /*onTap: () {
                setState(() {
                  print(selected[pos]);
                  selected[pos] = true;
                });
              },
              selected: selected[pos],*/
              selectedTileColor: Colors.grey.shade200,
              leading: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.assignment,
                  color: Colors.blue,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notificationData[pos].data.title,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_rounded,
                          size: 14,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Text(
                          getDateFormat(pos),
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  notificationData[pos].data.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  getDateFormat(int pos) {
    DateTime Date = DateTime.parse(notificationData[pos].updatedAt);
    return formatDate(Date, [hh, ':', nn,' ', am]);
  }
}
