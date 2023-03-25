import 'dart:async';

import 'package:chat_wave/firebase_options.dart';
import 'package:chat_wave/sereens/user_registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserRegistration()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome To Smart Talk',
            style: TextStyle(
              //color: Colors.white,

              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          const Text(
            'Smartest Communication Application',
            style: TextStyle(
              //color: Colors.white,

              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
