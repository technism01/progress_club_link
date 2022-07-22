import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';
import 'package:page_transition/page_transition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_club_link/common/PCChapters.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/component/loading_component.dart';
import 'package:progress_club_link/helper_functions/save_user_in_local.dart';
import 'package:progress_club_link/model/category_model.dart';
import 'package:progress_club_link/pages/cat_subcat_selection.dart';
import 'package:progress_club_link/pages/dashboard.dart';
import 'package:progress_club_link/providers/authentication_provider.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:progress_club_link/widgets/my_textform_field.dart';
import 'package:progress_club_link/widgets/rounded_elevatedbutton.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobileNumber = TextEditingController();
  TextEditingController txtChapter = TextEditingController();
  TextEditingController txtCompanyName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? pickedImage;
  List<CategorySubCategoryModel> selectedSubCatList = [];
  List<int> finalSubList = [];
  Uint8List? file1;
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  SubCategoryModel? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //getCategoryData();
    });
  }

  getCategoryData() async {
    await context.read<CategoryProvider>().getCategory().then((value) {
      if (value.success) {
        if (value.data != null) {
          setState(() {
            categoryList = value.data!;
          });
        }
      }
    });
  }

  uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        pickedImage = File(f, image.name);
        file1 = f;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Failed to pick image",
          webBgColor: "linear-gradient(to right, #5A5A5A, #5A5A5A)");
    }
  }

  registerUser() async {
    FormData data = FormData.fromMap({
      "name": txtName.text,
      "mobileNumber": txtMobileNumber.text,
      "companyName": txtCompanyName.text,
      "pcGroup": txtChapter.text,
      "subCategoryIds": json.encode(finalSubList),
    });

    if (file1 != null) {
      log("${pickedImage?.type}");
      MultipartFile file = MultipartFile.fromBytes(file1!,
          filename: pickedImage!.name,
          contentType: MediaType("image", "${pickedImage!.type}"));
      data.files.add(MapEntry("profile", file));
    }

    context
        .read<AuthenticationProvider>()
        .registerUser(data: data)
        .then((value) {
      if (value.success == true) {
        if (value.data == null) {
          Fluttertoast.showToast(
              msg: "Could not register, please try after sometime",
              webBgColor: "linear-gradient(to right, #5A5A5A, #5A5A5A)");
        } else {
          Fluttertoast.showToast(
              msg: "You register successfully",
              webBgColor: "linear-gradient(to right, #5A5A5A, #5A5A5A)");
          saveUserInLocal(value.data!);
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const Dashboard(
                  initialIndex: 0,
                ),
              ),
              (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 35,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/pc_logo.png",
                    height: 120,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                MyTextFormField(
                  controller: txtName,
                  hintText: "Enter Name",
                  label: "Name",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
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
                  validator: (value) {
                    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                    RegExp regExp = RegExp(pattern.toString());
                    if (value!.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Please enter valid mobile number';
                    } else if (value.length != 10) {
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
                  validator: (value) {
                    if (value!.isEmpty) {
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
                      validator: (value) {
                        if (value!.isEmpty) {
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
                Text(
                  "Business",
                  style: TextStyle(
                    fontSize: 13,
                    color: appPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Category:",
                              style: TextStyle(
                                fontSize: 12,
                                color: appPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Select category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: appPrimaryColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Sub Category:",
                              style: TextStyle(
                                fontSize: 12,
                                color: appPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Select sub category",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: appPrimaryColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Products:",
                              style: TextStyle(
                                fontSize: 12,
                                color: appPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Select products",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: appPrimaryColor,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: appPrimaryColor,
                        ),
                        Text(
                          "Add New",
                          style: TextStyle(
                            fontSize: 12,
                            color: appPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Profile Photo",
                  style: TextStyle(
                    fontSize: 13,
                    color: appPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                InkWell(
                  onTap: () {
                    uploadImage();
                  },
                  child: file1 != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.memory(
                            file1!,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          child: const Icon(
                            CupertinoIcons.person_alt,
                            size: 26,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 25,
                ),
                context.watch<AuthenticationProvider>().isLoading
                    ? const LoadingComponent()
                    : RoundedElevatedButton(
                        label: const Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        },
                      ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Already registered? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: appPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
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
                        fontSize: 15)),
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
                        child: Text(pcChapterList[index]),
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

  selectCategory(Function(String value) onSelect) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Select Category",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        fontSize: 15)),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(categoryList[index].name),
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
