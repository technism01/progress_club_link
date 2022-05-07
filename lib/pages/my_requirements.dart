import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/text_styles.dart';
import '../component/myRequirementList.dart';

class MyRequirement extends StatefulWidget {
  const MyRequirement({Key? key}) : super(key: key);

  @override
  State<MyRequirement> createState() => _MyRequirementState();
}

class _MyRequirementState extends State<MyRequirement>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      vsync: this,
      length: businessList.length,
    );
  }

  List businessList = [
    "Consultant",
    "IT Company",
    "Hospital",
    "GYM",
    "Consultant",
    "Marketing"
  ];

  List subCategoryList = [
    {
      "img":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg",
      "name": "Meghana Solanki",
      "bname": "Technism Infotech",
    },
    {
      "img": "https://webuildthemes.com/go/assets/images/demo/user-10.jpg",
      "name": "Mahi Solanki",
      "bname": "Semicolon Infotech",
    },
    {
      "img":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8C0eZ51cUVq9NO5x1H7Avc0eOMZrACwC_gIYztkQCcjMX_Ma5qf1fNWkSAoyU00YASkQ&usqp=CAU",
      "name": "Keval Mangroliya",
      "bname": "Logispire Solution",
    },
    {
      "img":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg",
      "name": "Chirag Mevada",
      "bname": "Apple Infotech",
    },
    {
      "img": "https://webuildthemes.com/go/assets/images/demo/user-10.jpg",
      "name": "Ruchit Mavani",
      "bname": "Semicolon Infotech",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: businessList.length,
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                isScrollable: true,
                unselectedLabelColor: appPrimaryColor,
                unselectedLabelStyle: MyTextStyles.medium.copyWith(
                  fontSize: 11,
                ),
                indicator: BubbleTabIndicator(
                    indicatorHeight: 36,
                    indicatorColor: appPrimaryColor,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    indicatorRadius: 5),
                tabs: businessList.map((e) {
                  return Container(
                    height: 34,
                    width: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: appPrimaryColor)),
                    child: Center(
                      child: Text(e,
                          style: MyTextStyles.medium.copyWith(
                            fontSize: 12,
                          )),
                    ),
                  );
                }).toList()),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                tabBarView(),
                tabBarView(),
                tabBarView(),
                tabBarView(),
                tabBarView(),
                tabBarView(),
              ]),
            )
          ],
        ),
      )),
    );
  }

  Widget tabBarView() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return StickyHeader(
              header: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade200,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Mobile App Development',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              content: MyRequirementList(memberList: subCategoryList));
        });
  }
}
