import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_club_link/pages/my_leads.dart';
import 'package:progress_club_link/pages/my_requirements.dart';
import 'package:progress_club_link/pages/profile_update.dart';

import '../common/TabIndicator.dart';
import '../common/constants.dart';
import '../common/text_styles.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'cat_subcat_selection.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController tabController;
  bool showFab = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      vsync: this,
      length: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 130,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "assets/images/pc_logo.png",
                    height: 100,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.person_alt),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileUpdate()));
                },
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
                height: 1,
              ),
              ListTile(
                leading: const Icon(Icons.login_rounded),
                title: const Text('Logout'),
                onTap: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: Text(
            "Let's Grow Together",
            style: MyTextStyles.semiBold.copyWith(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(
                    Icons.add,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Need"),
                ],
              ),
            ),
          ],
          leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu_rounded)),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            setState(() {
              if (direction == ScrollDirection.reverse) {
                showFab = false;
              } else if (direction == ScrollDirection.forward) {
                showFab = true;
              }
            });
            return true;
          },
          child: Column(
            children: [
              TabBar(
                  unselectedLabelStyle: MyTextStyles.semiBold,
                  unselectedLabelColor: Colors.grey,
                  labelColor: appPrimaryColor,
                  labelStyle: MyTextStyles.semiBold,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: appPrimaryColor,
                  indicator:
                      CustomTabIndicator(color: appPrimaryColor, height: 4),
                  controller: tabController,
                  tabs: const [Tab(text: "My Leads"), Tab(text: "My Needs")]),
              Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: const [MyLead(), MyRequirement()]))
            ],
          ),
        ),
        // floatingActionButton: tabController.index == 1
        //     ? AnimatedSlide(
        //         duration: const Duration(milliseconds: 300),
        //         offset: showFab ? Offset.zero : const Offset(0, 2),
        //         child: AnimatedOpacity(
        //           duration: const Duration(milliseconds: 300),
        //           opacity: showFab ? 1 : 0,
        //           child: FloatingActionButton.extended(
        //             backgroundColor: appPrimaryColor,
        //             icon: const Icon(Icons.filter_list_rounded,
        //                 color: Colors.white),
        //             onPressed: () {},
        //             label: const Text(
        //               "Filter",
        //               style: TextStyle(
        //                   color: Colors.white, fontWeight: FontWeight.w600),
        //             ),
        //           ),
        //         ),
        //       )
        //     : null,
      ),
    );
  }
}
