import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/common/text_styles.dart';

import '../common/PCChapters.dart';
import '../widgets/my_textform_field.dart';
import '../widgets/rounded_elevatedbutton.dart';
import 'cat_subcat_selection.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobileNumber = TextEditingController();
  TextEditingController txtChapter = TextEditingController();
  TextEditingController txtCompanyName = TextEditingController();
  List<List> selectedSubCatList = [];
  List finalSubList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    txtName.text = sharedPrefs.memberName;
    txtMobileNumber.text = sharedPrefs.mobileNo;
    txtCompanyName.text = sharedPrefs.companyName;
    txtChapter.text = sharedPrefs.pcGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Profile",
            style: MyTextStyles.semiBold.copyWith(
              fontSize: 16,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 20, top: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                      "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_3.jpg"),
                ),
                MyTextFormField(
                  controller: txtName,
                  hintText: "Enter Name",
                  label: "Name",
                  keyboardType: TextInputType.name,
                  validator: (phone) {
                    if (phone!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  controller: txtMobileNumber,
                  hintText: "Enter Mobile Number",
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  label: "Mobile Number",
                  validator: (phone) {
                    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                    RegExp regExp = RegExp(pattern.toString());
                    if (phone!.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (!regExp.hasMatch(phone)) {
                      return 'Please enter valid mobile number';
                    } else if (phone.length != 10) {
                      return "Please enter valid mobile number";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  controller: txtCompanyName,
                  hintText: "Enter Company Name",
                  keyboardType: TextInputType.text,
                  label: "Company Name",
                  validator: (phone) {
                    if (phone!.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    selectChapter((selectedValue) {
                      txtChapter.text = selectedValue;
                    });
                  },
                  child: AbsorbPointer(
                    child: MyTextFormField(
                      controller: txtChapter,
                      hintText: "Select Chapter",
                      keyboardType: TextInputType.number,
                      label: "Select Your Chapter",
                      validator: (phone) {
                        if (phone!.isEmpty) {
                          return 'Please select chapter';
                        }
                        return null;
                      },
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatSubCatSelection(
                          selectedList: selectedSubCatList,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        List finalList = [];
                        for (var element in value) {
                          for (var sub in element) {
                            finalList.add(sub);
                          }
                        }
                        setState(() {
                          selectedSubCatList = value;
                          finalSubList = finalList;
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: MyTextFormField(
                      hintText: finalSubList.isNotEmpty
                          ? "${finalSubList.length} selected"
                          : "Select business category",
                      keyboardType: TextInputType.number,
                      label: "Business Category",
                      validator: (phone) {
                        if (finalSubList.isEmpty) {
                          return 'Please select business category';
                        }
                        return null;
                      },
                      suffixIcon: const Icon(CupertinoIcons.add_circled_solid),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedElevatedButton(
                  label: const Text(
                    "Update",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectChapter(Function(String value) onSelect) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Select Chapter",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        fontSize: 17)),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: pcChapterList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onSelect(pcChapterList[index]);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(pcChapterList[index],
                            style: MyTextStyles.medium),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 0.2,
                      thickness: 0.4,
                      endIndent: 10,
                      indent: 10,
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
