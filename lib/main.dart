import 'dart:async';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/firebase_options.dart';
import 'package:chat_wave/utils/app_life_cycle.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/utils/provider.dart';
import 'package:chat_wave/views/home_page.dart';
import 'package:chat_wave/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsBinding.instance.addObserver(MyAppLifeCycleObserver());

  runApp(chatWaveProvider);
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
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
        const Duration(seconds: 3),
        () async {
          if(DBHandler.user !=null){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            await DBHandler.fireStoreData
                .collection(Collections.userDataCollection)
                .doc(DBHandler.user.uid)
                .update({'isOnline': 'Online'});
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );

          }


        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppConsts.appTitle,
            style: TextStyle(
              //color: Colors.white,

              fontSize: AppTextSize.largeText,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          const Text(
            AppConsts.appSplashSubTitle,
            style: TextStyle(
              //color: Colors.white,

              fontSize: AppTextSize.mediumText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
