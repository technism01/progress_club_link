import 'package:flutter/material.dart';
import 'package:progress_club_link/authentication/login.dart';
import 'package:progress_club_link/common/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sharing Link',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.light(
          primary: appPrimaryColor,
        ),
      ),
      home: const Login(),
    );
  }
}
