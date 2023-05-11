import 'dart:math';

import 'package:chat_wave/db_handler/auth_provider.dart';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/views/home_page.dart';
import 'package:chat_wave/widgets/custom_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
     /* appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              authProvider.logOut().then((value) => Navigator.of(context)
                  .pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false));
            },
            icon: const Icon(Icons.logout)),
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppConsts.appTitle,
              style: TextStyle(
                fontSize: AppTextSize.largeText,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                AppConsts.appSubTitle,
                style: TextStyle(
                  fontSize: AppTextSize.mediumText,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 32),
            InkWell(
              onTap: () async {
                try {
                  await AuthProvider.signInWithGoogle().then((user) async {
                    if (user != null) {
                      if (await DBHandler.userExists()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),

                        );
                        await DBHandler.fireStoreData
                            .collection(Collections.userDataCollection)
                            .doc(DBHandler.user.uid)
                            .update({'isOnline': 'Online'});
                      } else {
                        await DBHandler.createUser().then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );

                          Dialogs.showSnackBar(
                            context,
                            'Login succeed',
                          );
                        });
                        await DBHandler.fireStoreData
                            .collection(Collections.userDataCollection)
                            .doc(DBHandler.user.uid)
                            .update({'isOnline': 'Online'});

                      }
                    } else {
                      Dialogs.showSnackBar(context, 'Sign in failed',
                          isError: true);
                    }
                  });
                } catch (e) {
                  Dialogs.showSnackBar(context, 'SomeThing went wrong',
                      isError: true);
                }
              },

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  //width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    AppConsts.appLoginButton,
                    style: TextStyle(fontSize: AppTextSize.largeText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
