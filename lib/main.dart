import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:investing4you/helperclass/SharedPreferences.dart';
import 'package:investing4you/screen/dashboardPage.dart';
import 'package:investing4you/screen/splashPage.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return MyAppStates()._showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  SharedPrefs.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppStates createState() => MyAppStates();
}

class MyAppStates extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String fcmToken = "Getting Firebase Token";

  @override
  void initState() {
    requestingPermissionForIOS();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    super.initState();

    FirebaseMessaging.onMessage.listen((message) {
      // print(message);
      if (message.data.isNotEmpty) MyAppStates()._showNotification(message);
    });

    getTokens();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final String currentToken = SharedPrefs.getDeviceID;
      if (currentToken != token) {
        // print('token refresh: ' + token);
        await SharedPrefs.saveDeviceID(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Investing App',
      home: SplashScreen(),
      routes: {'/dashboardPage': (context) => DashboardPage()},
    );
  }

  requestingPermissionForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future _showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
      enableLights: true,
      playSound: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // print(message.data);
    Map<String, dynamic> data = message.data;
    // String fromMessage = 'Order ' + message.data['order_id'] + ' is available.';
    AndroidNotification android = message.notification?.android;
    if (data != null) {
      flutterLocalNotificationsPlugin.show(
        data.hashCode,
        data['title'],
        data['message'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.max,
            playSound: true,
            visibility: NotificationVisibility.public,
            showWhen: true,
            enableLights: true,
            icon: android?.smallIcon,
            // other properties...
          ),
          iOS: IOSNotificationDetails(presentAlert: true, presentSound: true),
        ),
        payload: 'Default_Sound',
      );
    }
  }

  getTokens() async {
    String token = await _firebaseMessaging.getToken();
    setState(() {
      fcmToken = token;
      SharedPrefs.saveDeviceID(fcmToken);
      // print(fcmToken);
    });
  }

  Future selectNotification(String payload) async {
    Navigator.of(context).pushNamed('/dashboardPage', arguments: 0);
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
