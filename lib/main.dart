import 'package:authentication/auth/categories/add.dart';
import 'package:authentication/auth/login.dart';
import 'package:authentication/auth/signup.dart';
import 'package:authentication/filter.dart';
import 'package:authentication/homepage.dart';
import 'package:authentication/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print('=======================BGGGGGGGGGGGGGGGGGGG');
  print(message.notification!.title);
  print(message.notification!.body);
  print('=======================');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('======================User is currently signed out!');
      } else {
        print('=======================User is signed in!');
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "firebase auth",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[50],
              titleTextStyle: TextStyle(
                color: Colors.purple,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.purple))),
      home: NotificationFire(),
      // (FirebaseAuth.instance.currentUser != null &&
      //         FirebaseAuth.instance.currentUser!.emailVerified)
      //     ? HomePage()
      //     : Login(),
      // routes: {
      //   "signup": (context) => const SignUp(),
      //   "login": (context) => const Login(),
      //   "homepage": (context) => const HomePage(),
      //   "addcategory": (context) => const AddCategory(),
      //   "Filterfirestore": (context) => const FilterFirestore(),
      // },
    );
  }
}
