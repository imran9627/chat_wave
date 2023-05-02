import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/user_info_model.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/views/login_page.dart';
import 'package:chat_wave/views/user_profile.dart';
import 'package:chat_wave/widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db_handler/auth_provider.dart';
import '../widgets/custom_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(AppConsts.appBarTitle),
          actions: [
            IconButton(
                onPressed: () {
                  authProvider.logOut().then((value) => Navigator.of(context)
                      .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false));
                },
                icon: const Icon(Icons.logout)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfile()));
                },
                icon: const Icon(Icons.person)),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search',
              onChanged: (String) {},
              onSubmitted: (String) {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: StreamBuilder<QuerySnapshot>(
                stream: DBHandler.userCollection(
                        collection: Collections.userDataCollection)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print('//////////////////doc//////////////${snapshot}');

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> doc = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;

                      return CustomListTile(
                        avatar: CircleAvatar(
                          child: doc.containsKey(UserPersonalInfo.keyImageUrl)
                              ? Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(doc[UserPersonalInfo.keyImageUrl]),
                          )
                              : const Icon(Icons.person),
                        ),
                        title: doc[UserPersonalInfo.keyUserName],
                        subTitle: doc[UserPersonalInfo.keyContact],
                        timeStamp: doc[UserPersonalInfo.keyAbout],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
