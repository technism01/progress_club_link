import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../common/constants.dart';
import '../common/text_styles.dart';

class MyLeadList extends StatefulWidget {
  final List memberList;
  const MyLeadList({required this.memberList, Key? key}) : super(key: key);

  @override
  State<MyLeadList> createState() => _MyLeadListState();
}

class _MyLeadListState extends State<MyLeadList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.memberList.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 0.8),
                borderRadius: BorderRadius.circular(4),
                //    color: Colors.grey.withOpacity(0.1)
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            e["img"],
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
                                e["name"],
                                style: MyTextStyles.semiBold.copyWith(
                                  fontSize: 14,
                                  color: appPrimaryColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Text(
                                  e["bname"],
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
                          onTap: () async {
                            const url = WhatsAppUnilink(
                              phoneNumber: '+919429828152',
                              text:
                                  "Hey! I'm inquiring about the apartment listing",
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
                            launchUrl(Uri.parse("tel://9429828152"));
                          },
                          child: const Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Icon(
                                CupertinoIcons.phone_fill,
                                color: Color(0xff3a335f),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              )),
        );
      }).toList(),
    );
  }
}
