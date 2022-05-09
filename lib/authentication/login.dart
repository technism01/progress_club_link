import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/authentication/registration.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/component/loading_component.dart';
import 'package:progress_club_link/helper_functions/save_user_in_local.dart';
import 'package:progress_club_link/pages/dashboard.dart';
import 'package:progress_club_link/providers/authentication_provider.dart';
import 'package:progress_club_link/widgets/my_textform_field.dart';
import 'package:progress_club_link/widgets/rounded_elevatedbutton.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtMobileNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  login() async {
    context
        .read<AuthenticationProvider>()
        .loginUser(mobileNo: txtMobileNumber.text)
        .then((value) {
      if (value.success) {
        saveUserInLocal(value.data!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/tagline.png", width: 500),
                  const SizedBox(
                    height: 35,
                  ),
                  Image.asset(
                    "assets/images/pc_logo.png",
                    height: 120,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  MyTextFormField(
                    controller: txtMobileNumber,
                    hintText: "Enter your mobile number",
                    maxLength: 10,
                    label: "Mobile Number",
                    keyboardType: TextInputType.phone,
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
                    height: 25,
                  ),
                  context.watch<AuthenticationProvider>().isLoading
                      ? const LoadingComponent()
                      : RoundedElevatedButton(
                          label: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registration()));
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "New user? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextSpan(
                          text: "Register Here",
                          style: TextStyle(
                            color: appPrimaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
