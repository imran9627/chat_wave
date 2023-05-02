import 'dart:io';

import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/user_info_model.dart';
import 'package:chat_wave/repository/firebase_services/services.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/widgets/custom_camera_icon.dart';
import 'package:chat_wave/widgets/custom_list_tile.dart';
import 'package:chat_wave/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_avatar.dart';
import '../widgets/custom_dialogs.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController nameController;
  late TextEditingController aboutController;
  late TextEditingController phoneController;
  bool isLoading = false;
  late XFile? pickedImage = null;
  var imageUrl;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    nameController = TextEditingController();
    aboutController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataSource = Provider.of<FirebaseDataSource>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppConsts.settings),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                Stack(alignment: Alignment.bottomRight, children: [
                  FutureBuilder(
                    future: dataSource.uploadImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          print('...........Snapshot image...${snapshot.data}');
                          return CustomAvatar(
                              radius: 40,
                              imageProvider: NetworkImage(
                                '${snapshot.data}',
                              ));
                        } else {
                          return const CustomAvatar(
                            radius: 40,
                            child: Icon(Icons.person),
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  const CameraIcon()
                ]),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  labelText: 'Name',
                  controller: nameController,
                ),
                InputField(
                  labelText: 'About me',
                  controller: aboutController,
                ),
                InputField(
                  labelText: 'Phone',
                  controller: phoneController,
                ),
                InkWell(
                  onTap: () async {
                    print('/////////////////${imageUrl}');
                    // if (pickedImage != null) {
                      if (nameController.text.isNotEmpty &&
                          aboutController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isLoading = true;
                        });
                        imageUrl = await dataSource.uploadImage();

                        var data = UserPersonalInfo(
                            imageUrl: imageUrl,
                            userName: nameController.text,
                            about: aboutController.text,
                            contact: phoneController.text);

                        DBHandler.userCollection(
                                collection: Collections.userDataCollection)
                            .doc()
                            .set(data.toMap())
                            .whenComplete(() => Dialogs.showSnackBar(
                                context, 'Data Inserted successfully'));
                      } else {
                        Dialogs.showSnackBar(context, 'please fill all fields', isError: true);
                      }
                    // } else {
                    //   Dialogs.showSnackBar(context, 'Failed', isError: true);
                    // }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      //width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        AppConsts.updateProfilebtn,
                        style: TextStyle(fontSize: AppTextSize.largeText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
