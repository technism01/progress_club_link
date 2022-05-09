import 'dart:developer';

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/common/string_constants.dart';
import 'package:progress_club_link/common/text_styles.dart';
import 'package:progress_club_link/helper_functions/SelectedCategoryTOCategorySubCate.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../common/PCChapters.dart';
import '../component/loading_component.dart';
import '../helper_functions/save_user_in_local.dart';
import '../providers/authentication_provider.dart';
import '../widgets/my_textform_field.dart';
import '../widgets/rounded_elevatedbutton.dart';
import 'cat_subcat_selection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';


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
  List<CategorySubCategoryModel> selectedSubCatList = [];
  List<int> finalSubList = [];
  final _formKey = GlobalKey<FormState>();
  File? pickedImage;
  String profileImage = "";

  updateProfile() async {
    FormData data = FormData.fromMap({
      "id":sharedPrefs.memberId,
      "name": txtName.text,
      //"mobileNumber": txtMobileNumber.text,
      "companyName": txtCompanyName.text,
      "pcGroup": txtChapter.text,
      "subCategoryIds": json.encode([5,6])//json.encode(finalSubList),
    });
    final bytes = await pickedImage!.readAsBytes();
    final MultipartFile file = MultipartFile.fromBytes(bytes, filename: "profilePhoto");
    MapEntry<String, MultipartFile> imageFiles = MapEntry("profile", file);

    data.files.add(imageFiles);

    context.read<AuthenticationProvider>()
        .updateUserProfile(formData:data)
        .then((value) {
      if (value.success == true) {
        if (value.data == null) {
          Fluttertoast.showToast(
              msg: "Could not Update");
        } else {
          Fluttertoast.showToast(msg: "Profile Update Successfully!");
          saveUserInLocal(value.data!);
        }
      }
    });
  }


  @override
  void initState() {
    super.initState();
    txtName.text = sharedPrefs.memberName;
    txtMobileNumber.text = sharedPrefs.mobileNo;
    txtCompanyName.text = sharedPrefs.companyName;
    txtChapter.text = sharedPrefs.pcGroup;
    profileImage = sharedPrefs.profile;
    selectedSubCatList =
        selectedCategoryTOCategorySubCate(sharedPrefs.selected);
    makeList(selectedSubCatList);
  }

  makeList(List<CategorySubCategoryModel> list) {
    List<int> finalList = [];
    for (var element in list) {
      for (var sub in element.subIdList) {
        finalList.add(sub);
      }
    }
    setState(() {
      finalSubList = finalList;
    });
  }

  Future<File?> _getFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> _getFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  void _imagePick() {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 1,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 36,
                          width: 36,
                        ),
                        Text(
                          "Choose option",
                          style: MyTextStyles.semiBold.copyWith(fontSize: 16),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: const Color(0xcceeeeee),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 21,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      pickedImage = await _getFromCamera();

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "Camera",
                      style: MyTextStyles.medium.copyWith(fontSize: 14),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      pickedImage = await _getFromGallery();

                      if (pickedImage == null) {
                        Fluttertoast.showToast(msg: "failed to pick image");
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 15),
                      child: Icon(
                        Icons.photo,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "Upload from gallery",
                      style: MyTextStyles.medium.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
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
                InkWell(
                    onTap: () {
                      _imagePick();
                    },
                    child: profileImage == ""
                        ? pickedImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(pickedImage!.path))
                            : const CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage("images/user.png"))
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                StringConstants.apiUrl + profileImage))),
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
/*
                GestureDetector(
                  onTap: () async {
                    await context
                        .read<CategoryProvider>()
                        .getCategory()
                        .then((value) {
                      if (value.success) {
                        if (value.data != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CatSubCatSelection(
                                  categoryList: value.data!,
                                  selectedList: selectedSubCatList,
                                  isFromDashboard: false,
                                ),
                              )).then((value) {
                            if (value != null) {
                              List<CategorySubCategoryModel> list =
                                  value as List<CategorySubCategoryModel>;
                              setState(() {
                                selectedSubCatList = list;
                              });
                              makeList(list);
                            }
                          });
                        }
                      }
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CatSubCatSelection(
                    //       selectedList: selectedSubCatList,
                    //     ),
                    //   ),
                    // ).then((value) {
                    //   if (value != null) {
                    //     List finalList = [];
                    //     for (var element in value) {
                    //       for (var sub in element) {
                    //         finalList.add(sub);
                    //       }
                    //     }
                    //     setState(() {
                    //       selectedSubCatList = value;
                    //       finalSubList = finalList;
                    //     });
                    //   }
                    // });
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
*/
                const SizedBox(
                  height: 20,
                ),
                context.watch<AuthenticationProvider>().isLoading
                    ? const LoadingComponent()
                    : RoundedElevatedButton(
                  label: const Text(
                    "Update",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateProfile();
                    }
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
