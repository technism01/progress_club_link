import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/model/myneed_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../common/constants.dart';
import '../common/shared_preferences.dart';
import '../common/text_styles.dart';

class MyRequirementList extends StatefulWidget {
  final List<MyNeedMember> memberList;

  const MyRequirementList({required this.memberList, Key? key})
      : super(key: key);

  @override
  State<MyRequirementList> createState() => _MyRequirementListState();
}

class _MyRequirementListState extends State<MyRequirementList> {
  @override
  Widget build(BuildContext context) {
    return widget.memberList.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.memberList.map((e) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade200, width: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      //    color: Colors.grey.withOpacity(0.1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 16,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: e.profile == null
                                      ? Image.asset(
                                          "assets/images/user.png",
                                          height: 60,
                                          width: 60,
                                        )
                                      : Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  alignment:
                                                      FractionalOffset.center,
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(
                                                    StringConstants.imageUrl +
                                                        "${e.profile}",
                                                  ))),
                                        ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name!,
                                          style: MyTextStyles.semiBold.copyWith(
                                            fontSize: 14,
                                            color: appPrimaryColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Text(
                                            e.pcGroup!,
                                            style:
                                                MyTextStyles.semiBold.copyWith(
                                              fontSize: 10,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Text(
                                            e.companyName!,
                                            style:
                                                MyTextStyles.semiBold.copyWith(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var url = WhatsAppUnilink(
                                      phoneNumber: '+91${e.mobileNumber}',
                                      text:
                                          "Hi, My name is ${sharedPrefs.memberName} Proud Member of ${sharedPrefs.pcGroup}",
                                    );

                                    await launchUrl(Uri.parse('$url'));
                                  },
                                  child: Image.asset(
                                    "assets/images/whtsp.png",
                                    width: 28,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    launchUrl(
                                        Uri.parse("tel://${e.mobileNumber}"));
                                  },
                                  child: const Padding(
                                      padding: EdgeInsets.only(right: 2),
                                      child: Icon(
                                        CupertinoIcons.phone_fill,
                                        color: Color(0xff3a335f),
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }).toList(),
          )
        : SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "No data found",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          );
  }
}
