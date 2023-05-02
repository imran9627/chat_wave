import 'package:chat_wave/repository/firebase_services/services.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraIcon extends StatelessWidget {
  const CameraIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseServicesProvider =
        Provider.of<FirebaseDataSource>(context, listen: false);
    return Positioned(
      bottom: -10,
      right: -10,
      child: IconButton(
        onPressed: () {
          firebaseServicesProvider.pickedImage();
        },
        icon: const Icon(
          Icons.camera_alt,
          color: AppColors.amber,
        ),
      ),
    );
  }
}
