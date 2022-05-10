import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_club_link/authentication/login.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/pages/my_leads.dart';
import 'package:progress_club_link/pages/my_requirements.dart';
import 'package:progress_club_link/pages/profile_update.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import '../common/TabIndicator.dart';
import '../common/constants.dart';
import '../common/text_styles.dart';
import 'cat_subcat_selection.dart';
import 'package:page_transition/page_transition.dart';

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

  showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                SharedPrefs().logout().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRight, child: Login()),
                      (route) => false);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  fontSize: 14,
                  color: appPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
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
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const ProfileUpdate()));
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
                onTap: () {
                  Navigator.pop(context);
                  showLogoutDialog();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Let's Grow Together",
            style: MyTextStyles.semiBold.copyWith(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                context.read<CategoryProvider>().getCategory().then((value) {
                  if (value.success) {
                    if (value.data != null) {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: CatSubCatSelection(
                                title: "Search Your Need",
                                categoryList: value.data!,
                                selectedList: const [],
                                isFromDashboard: true,
                              ))).then((value) {
                        setState(() {});
                      });
                    }
                  }
                });
              },
              child: context.watch<CategoryProvider>().isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: const [
                        Icon(
                          Icons.add_box_rounded,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Connect"),
                        SizedBox(width: 10)
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
                      CustomTabIndicator(color: appPrimaryColor, height: 3),
                  controller: tabController,
                  tabs: const [Tab(text: "My Leads"), Tab(text: "My Needs")]),
              Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: const [MyLead(), MyRequirement()]))
            ],
          ),
        ),
      ),
    );
  }
}
