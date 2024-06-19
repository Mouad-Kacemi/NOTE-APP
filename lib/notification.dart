import 'dart:convert';
import 'package:authentication/chat.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationFire extends StatefulWidget {
  const NotificationFire({Key? key}) : super(key: key);

  @override
  State<NotificationFire> createState() => _NotificationFireState();
}

class _NotificationFireState extends State<NotificationFire> {
  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print("-------------------------");
    print(myToken);
  }

  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (initialMessage!.data['name'] == 'chat') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Chat()));
      }
    }
  }

  myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
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
  }

  @override
  void initState() {
    getInit();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['name'] == "chat") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Chat()));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('=======================');
        print(message.notification!.title);
        print(message.notification!.body);
        print('=======================');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${message.notification!.body}')));
        super.initState();

        // Use the _scaffoldKey to get the Scaffold state
      }
    });
    myRequestPermission();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                await FirebaseMessaging.instance.subscribeToTopic("Mouad");
              },
              child: Text('subscribe'),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () async {
              await FirebaseMessaging.instance.unsubscribeFromTopic("Mouad");
            },
            child: Text('unsubscribe'),
          ),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () async {
              await sendNotificationTopic("HEY", "Tomer", "Mouad");
            },
            child: Text('Activate notifications'),
          ),
        ],
      )),
    );
  }
}

sendNotification(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAarIZYbY:APA91bH12gSEloHELbB9t7c8C7s-cOX4V91PCSBSeSJ9PHo6uxkvB-WSQZzvYYUQp-bklsSZ9IwZRS6ZNA61-qV1t5EOQ31wTmQ5aSYmwjk5FDndwxq8s13nCk3mWUZDeI85E68UfKRf',
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "cks3v0t-zexfsxMs2nINqm:APA91bGHEAGy6n223etvhv_oZeK2gth-dvHXzMnQXgxxsuJjlNSt6SZtLGbYtU-JqN__g4cP9On9ujzgzaGIUUVmPtGJwYduHYqD3x6IRLrLsW2eRCvtC0b_CbX89zNoSowv_bcK3J2Q",
    "notification": {"title": title, "body": message, "sound": "Tri-tone"},
  };

  var req = Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}

sendNotificationTopic(title, message, topic) async {
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAAarIZYbY:APA91bH12gSEloHELbB9t7c8C7s-cOX4V91PCSBSeSJ9PHo6uxkvB-WSQZzvYYUQp-bklsSZ9IwZRS6ZNA61-qV1t5EOQ31wTmQ5aSYmwjk5FDndwxq8s13nCk3mWUZDeI85E68UfKRf',
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {"title": title, "body": message, "sound": "Tri-tone"},
  };

  var req = Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
