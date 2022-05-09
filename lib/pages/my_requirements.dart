import 'dart:io';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/model/myneed_model.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/EmptyScreen.dart';
import '../common/text_styles.dart';
import '../component/loading_component.dart';
import '../component/myRequirementList.dart';
import '../providers/lead_reuquirement_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyRequirement extends StatefulWidget {
  const MyRequirement({Key? key}) : super(key: key);

  @override
  State<MyRequirement> createState() => _MyRequirementState();
}

class _MyRequirementState extends State<MyRequirement>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<NeedCategoryModel> myNeedList = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(const Duration(seconds: 0)).then((value) {
      getMyNeeds();
    });
  }

  getMyNeeds() async {
    context
        .read<LeadRequirementProvider>()
        .getMyNeeds(memberID: sharedPrefs.memberId)
        .then((value) {
      if (value.success == true) {
        if (value.data == null) {
        } else {
          setState(() {
            myNeedList = value.data!;
            _tabController =
                TabController(length: myNeedList.length, vsync: this);
          });

          print(myNeedList.length);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myNeedList.length,
      child: Scaffold(
        body: context.watch<LeadRequirementProvider>().isLoading
            ? const LoadingComponent()
            : myNeedList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            controller: _tabController,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
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
                            tabs: myNeedList.map((e) {
                              int index = myNeedList.indexOf(e);
                              return Container(
                                height: 34,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: appPrimaryColor)),
                                child: Center(
                                  child: Text("${e.name}",
                                      textAlign: TextAlign.center,
                                      style: MyTextStyles.medium.copyWith(
                                        fontSize: 12,
                                      )),
                                ),
                              );
                            }).toList()),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(
                              controller: _tabController,
                              children: myNeedList.map((e) {
                                int catIndex = myNeedList.indexOf(e);
                                return myNeedView(
                                    subCategory:
                                        myNeedList[catIndex].subCategory!);
                              }).toList()),
                        )
                      ],
                    ),
                  )
                : const EmptyScreen(
                    title: "No Leads Found", image: "assets/images/user.png"),
      ),
    );
  }

  Widget myNeedView({required List<NeedSubCategoryModel> subCategory}) {
    return ListView.builder(
        itemCount: subCategory.length,
        itemBuilder: (context, index) {
          return StickyHeader(
              header: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    subCategory[index].name!,
                    style: MyTextStyles.semiBold
                        .copyWith(color: Colors.grey.shade800),
                  ),
                ),
              ),
              content:
                  MyRequirementList(memberList: subCategory[index].member!));
        });
  }
}
