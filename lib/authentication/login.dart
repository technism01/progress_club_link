import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/authentication/registration.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/widgets/my_textform_field.dart';
import 'package:progress_club_link/widgets/rounded_elevatedbutton.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtMobileNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/tagline.png", width: 500),
              Image.asset(
                "assets/images/pc_logo.png",
                height: 120,
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 35,
              ),
              const SizedBox(
                height: 6,
              ),
              MyTextFormField(
                controller: txtMobileNumber,
                hintText: "Enter your mobile number",
                maxLength: 10,
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
                height: 25,
              ),
              RoundedElevatedButton(
                label: const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
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
                  text: const TextSpan(
                    text: "Not registered?",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
