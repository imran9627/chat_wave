import 'package:chat_wave/main.dart';
import 'package:chat_wave/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db_handler/auth_provider.dart';
import '../repository/firebase_services/services.dart';

Widget get chatWaveProvider{
  return MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
    ),
    ChangeNotifierProvider<FirebaseDataSource>(
      create: (context) => FirebaseDataSource(),
    ),

  ], child:  MyApp(),);
}