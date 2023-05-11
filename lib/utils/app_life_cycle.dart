import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAppLifeCycleObserver extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    DateFormat timeFormat = DateFormat('hh:mm a');
    String formattedDate = dateFormat.format(DateTime.now());
    String formattedTime = timeFormat.format(DateTime.now());
    switch (state) {
      case AppLifecycleState.paused:
        await DBHandler.fireStoreData
            .collection(Collections.userDataCollection)
            .doc(DBHandler.user.uid)
            .update({'isOnline': '$formattedDate at $formattedTime'});
        break;
      case AppLifecycleState.resumed:
        await DBHandler.fireStoreData
            .collection(Collections.userDataCollection)
            .doc(DBHandler.user.uid)
            .update({'isOnline': 'Online'});
        break;
      case AppLifecycleState.inactive:
        await DBHandler.fireStoreData
            .collection(Collections.userDataCollection)
            .doc(DBHandler.user.uid)
            .update({'isOnline': '$formattedDate at $formattedTime'});
        break;
      case AppLifecycleState.detached:
        await DBHandler.fireStoreData
            .collection(Collections.userDataCollection)
            .doc(DBHandler.user.uid)
            .update({'isOnline': '$formattedDate at $formattedTime'});
        break;
    }
  }
}
