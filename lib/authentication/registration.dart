import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/widgets/my_textform_field.dart';
import 'package:progress_club_link/widgets/rounded_elevatedbutton.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController txtMobileNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 35,
              ),
              Image.asset(
                "assets/images/pc_logo.png",
                height: 120,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "मेरा बिज़नेस तो क्लब में ही",
                style: TextStyle(
                  fontSize: 13,
                  color: appPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontSize: 13,
                    color: appPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              MyTextFormField(
                controller: txtMobileNumber,
                hintText: "Enter your mobile number",
                maxLength: 10,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
