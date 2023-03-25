import 'package:chat_wave/repository/firebase_services/services.dart';
import 'package:chat_wave/widgets/input_field.dart';
import 'package:flutter/material.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  late TextEditingController nameController;
  late TextEditingController contactController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    contactController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InputField(
            hintText: 'Name',
            controller: nameController,
          ),
          SizedBox(
            height: 10,
          ),
          InputField(
            hintText: 'Contact',
            controller: contactController,
            inputType: TextInputType.phone,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseDataSource.addUser(
                    userName: nameController.text,
                    contact: int.parse(contactController.text),
                    context: context);
              },
              child: const Text('Continue'))
        ],
      ),
    );
  }
}
