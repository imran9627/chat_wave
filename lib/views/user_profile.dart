import 'dart:io';
import 'dart:math';

import 'package:chat_wave/db_handler/auth_provider.dart';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/chat_model.dart';
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
import 'login_page.dart';

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
  late TextEditingController emailController;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? file;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    nameController = TextEditingController();
    aboutController = TextEditingController();
    emailController = TextEditingController();





  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    emailController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // var dataSource = Provider.of<FirebaseDataSource>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
                onPressed: () {
                  AuthProvider.logOut().then((value) => Navigator.of(context)
                      .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false));
                },
                icon: const Icon(Icons.logout)),
          ],
          centerTitle: true,
          title: const Text(AppConsts.settings),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: FutureBuilder(
              future: DBHandler.getSelfInfo(),
              builder: (context, snapshot) {



                  if(snapshot.hasData) {
                    var data = snapshot.data;
                    nameController.text = data!.name!;
                    aboutController.text = data.about!;
                    emailController.text = data.email!;
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.07,),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (snapshot.connectionState ==
                                ConnectionState.done)
                              if(file == null)
                                CustomAvatar(
                                  radius: 50,
                                  imageProvider: NetworkImage('${data.image}'),
                                )

                              else
                                CustomAvatar(
                                  radius: 40,
                                  imageProvider: FileImage(file!),
                                ),
                            CameraIcon(onPressed: () async {
                              file = await FirebaseDataSource.pickedImage();
                              setState(() {

                              });
                            },)
                          ],
                        ),
                        const SizedBox(height: 30),
                        InputField(
                          labelText: 'Name',
                          controller: nameController,

                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "required";
                            }
                          },
                          prefix: const Icon(
                              Icons.person, color: AppColors.blue),


                        ),
                        InputField(
                          labelText: 'About me',
                          controller: aboutController,
                          prefix:
                          const Icon(Icons.info_outline, color: AppColors.blue),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "required";
                            }
                          },

                        ),
                        InputField(
                          labelText: 'Email',
                          controller: emailController,
                          prefix: const Icon(
                              Icons.email, color: AppColors.blue),

                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "required";
                            }
                          },

                        ),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              var imageUrl = await FirebaseDataSource
                                  .uploadImage(imageFile: file);
                              DBHandler.updateUser(
                                  nameController.text, aboutController.text,
                                  imageUrl.toString());
                              Dialogs.showSnackBar(
                                  context, 'edited data updated successfully');
                              print('validator');
                            } else {
                              Dialogs.showSnackBar(
                                  context, 'Please fill all fields');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                AppConsts.updateProfilebtn,
                                style: TextStyle(
                                    fontSize: AppTextSize.largeText),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator());

                }


              },
            ),
          ),
        ));
  }
}
