import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/text_styles.dart';

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
      "group": "Digital Marketing",
      "img":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg",
      "name": "Meghana Solanki",
      "bname": "Technism Infotech",
    },
    {
      "group": "Digital Marketing",
      "img": "https://webuildthemes.com/go/assets/images/demo/user-10.jpg",
      "name": "Mahi Solanki",
      "bname": "Semicolon Infotech",
    },
    {
      "group": "Web Designing",
      "img":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8C0eZ51cUVq9NO5x1H7Avc0eOMZrACwC_gIYztkQCcjMX_Ma5qf1fNWkSAoyU00YASkQ&usqp=CAU",
      "name": "Keval Mangroliya",
      "bname": "Logispire Solution",
    },
    {
      "group": "Web Designing",
      "img":
          "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg",
      "name": "Chirag Mevada",
      "bname": "Apple Infotech",
    },
    {
      "group": "Web Designing",
      "img": "https://webuildthemes.com/go/assets/images/demo/user-10.jpg",
      "name": "Ruchit Mavani",
      "bname": "Semicolon Infotech",
    },
  ];

  void launchWhatsApp({
    required int phone,
    required String message,
  }) async {
    Uri url() {
      if (Platform.isAndroid) {
        return Uri.parse(
            "whatsapp://wa.me/$phone:03452121308:/?text=${Uri.parse(message)}");
      } else {
        return Uri.parse(
            "whatsapp://send?   phone=$phone&text=${Uri.parse(message)}");
      }
    }

    if (await canLaunchUrl(url())) {
      await launchUrl(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: businessList.length,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              "My Requirement",
              style: MyTextStyles.semiBold.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
      child: GroupedListView<dynamic, String>(
        elements: subCategoryList,
        groupBy: (element) => element['group'],
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']),
        order: GroupedListOrder.DESC,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Text(value, style: MyTextStyles.bold.copyWith(fontSize: 13)),
        ),
        itemBuilder: (c, element) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: appPrimaryColor.withOpacity(0.2), width: 0.8),
                  borderRadius: BorderRadius.circular(4),
                  //    color: Colors.grey.withOpacity(0.1)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              element["img"],
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element["name"],
                                  style: MyTextStyles.semiBold.copyWith(
                                    fontSize: 14,
                                    color: appPrimaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Text(
                                    element["bname"],
                                    style: MyTextStyles.semiBold.copyWith(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Image.asset(
                              "assets/images/whtsp.png",
                              width: 28,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Image.asset(
                                "assets/images/phone.png",
                                width: 18,
                                height: 18,
                                color: appPrimaryColor,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
