import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/chat_model.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/views/chat_page.dart';
import 'package:chat_wave/views/user_profile.dart';
import 'package:chat_wave/widgets/custom_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ChatModel user = ChatModel();
  bool isSearching = false;
  List<ChatModel> searchList = [];
  List<ChatModel> listOfUsers = [];


  Future<void> _refresh() async {
    // Add your refresh logic here
    setState(() {
      print('//////////////refreshed////////////');
    });
  }


  @override
  Widget build(BuildContext context) {
    //var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: AppColors.white,
              centerTitle: true,
              title: isSearching
                  ? CustomSearchBar(
                      hintText: 'Search',
                      onChanged: (value) {
                        searchList.clear();
                        for (var index in listOfUsers) {
                          if (index.name!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              index.email!
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            searchList.add(index);
                          }
                          setState(() {
                            searchList;
                          });
                        }
                      },
                      onSubmitted: (value) {},
                    )
                  : const Text(AppConsts.appBarTitle,
                      style: TextStyle(color: Colors.red)),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                        searchList.clear();
                      });
                    },
                    icon: Icon(
                      isSearching
                          ? CupertinoIcons.clear_circled
                          : Icons.search_rounded,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserProfile()));

                      if (result != null) {
                        setState(() {
                          // Update the state of your widget to reflect the refreshed data
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    )),
              ]),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: FutureBuilder<List<ChatModel>>(
                future: DBHandler.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    listOfUsers = snapshot.data!;
                    return isSearching
                        ? ListView.builder(
                            dragStartBehavior: DragStartBehavior.start,
                            itemCount: searchList.length,
                            itemBuilder: (context, index) {
                              return CustomListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPage(document: searchList[index]),
                                    )),
                                avatar: CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      fit: BoxFit.fill,
                                      imageUrl: '${searchList[index].image}',
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                                title: '${searchList[index].name}',
                                subTitle: '${searchList[index].email}',
                                timeStamp:
                                    listOfUsers[index].isOnline == 'Online'
                                        ? "Online"
                                        : "Offline",
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: listOfUsers.length,
                            itemBuilder: (context, index) {
                              return CustomListTile(
                                onTap: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            document: listOfUsers[index]),
                                      ));
                                  if (result != null) {
                                    setState(() {
                                      // Update the state of your widget to reflect the refreshed data
                                    });
                                  }
                                },
                                avatar: CircleAvatar(
                                  child: ClipRRect(

                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                      MediaQuery.of(context).size.width *
                                          0.1,
                                      fit: BoxFit.fill,
                                      imageUrl: '${listOfUsers[index].image}',
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                                title: '${listOfUsers[index].name}',
                                subTitle: '${listOfUsers[index].email}',
                                timeStamp:
                                    listOfUsers[index].isOnline == 'Online'
                                        ? "Online"
                                        : "Offline",
                              );
                            },
                          );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
