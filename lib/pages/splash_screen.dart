import 'package:flutter/material.dart';
import 'package:progress_club_link/authentication/login.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/pages/dashboard.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (sharedPrefs.memberId != 0) {
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const Dashboard()));
      } else {
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/tagline.png",
            width: 500,
          ),
          const SizedBox(
            height: 35,
          ),
          Image.asset(
            "assets/images/pc_logo.png",
            height: 120,
          ),
        ],
      ),
    );
  }
}
