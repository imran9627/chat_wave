import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({Key? key}) : super(key: key);

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs>
    with SingleTickerProviderStateMixin {
  //late TabController tabController;

  List<Tab> listOfTabs = [
    const Tab(
        child: Icon(
      Icons.group_add,
      size: AppTextSize.xxLargeText,
    )),
    const Tab(text: AppConsts.chatLabel),
    const Tab(text: AppConsts.statusLabel),
    const Tab(text: AppConsts.callsLabel),
  ];
  List<Widget> listOfTabsViews = [
    MyLabel(label: "Group"),
    MyLabel(label: "Chat"),
    MyLabel(label: "Status"),
    MyLabel(label: "Calls"),
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.white,
              // controller: tabController,
              tabs: listOfTabs,
              onTap: (value) {
                print('index of tabs: $value');
              },
            ),
          ),
          body: TabBarView(
              // controller: tabController,
              children: listOfTabsViews)),
    );
  }
}

class MyLabel extends StatelessWidget {
  final String label;

  const MyLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
            fontSize: AppTextSize.largeText, color: AppColors.primary),
      ),
    );
  }
}
