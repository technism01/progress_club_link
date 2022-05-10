import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/providers/lead_reuquirement_provider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../common/EmptyScreen.dart';
import '../common/text_styles.dart';
import '../component/loading_component.dart';
import '../component/myLeadList.dart';
import '../model/mylead_model.dart';

class MyLead extends StatefulWidget {
  const MyLead({Key? key}) : super(key: key);

  @override
  State<MyLead> createState() => _MyLeadState();
}

class _MyLeadState extends State<MyLead> with TickerProviderStateMixin {
  TabController? _tabController;
  List<LeadCategoryModel> myLeadList = [];

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(const Duration(seconds: 0)).then((value) {
      getMyLeads();
    });
  }

  getMyLeads() async {
    context
        .read<LeadRequirementProvider>()
        .getMyLeads(memberID:sharedPrefs.memberId)
        .then((value) {
      if (value.success == true) {
        if (value.data == null) {
        } else {
          setState(() {
            myLeadList = value.data!;
            _tabController =
                TabController(length: myLeadList.length, vsync: this);
          });

          print(myLeadList.length);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myLeadList.length,
      child: Scaffold(
        body: context.watch<LeadRequirementProvider>().isLoading
            ? const LoadingComponent()
            : myLeadList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                indicatorHeight: 40,
                                indicatorColor: appPrimaryColor,
                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                indicatorRadius: 5),
                            tabs: myLeadList.map((e) {
                              int index = myLeadList.indexOf(e);
                              return Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
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
                              children: myLeadList.map((e) {
                                int categoryIndex = myLeadList.indexOf(e);
                                return myLeadsView(
                                    subCategory:
                                        myLeadList[categoryIndex].subCategory!);
                              }).toList()),
                        )
                      ],
                    ),
                  )
                : const EmptyScreen(
                    title: "No Leads Found", image: "assets/images/nosearchfound.png"),
      ),
    );
  }

  Widget myLeadsView({required List<LeadSubCategory> subCategory}) {
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
                    "${subCategory[index].name}",
                    style: MyTextStyles.semiBold
                        .copyWith(color: Colors.grey.shade800),
                  ),
                ),
              ),
              content: MyLeadList(memberList: subCategory[index].member!));
        });
  }
}
