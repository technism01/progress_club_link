import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/authentication/login.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

final mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await sharedPrefs.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: appPrimaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 18),
          iconTheme: IconThemeData(
            color: appPrimaryColor,
          ),
        ),
      ),
      home: const Login(),
    );
  }
}
