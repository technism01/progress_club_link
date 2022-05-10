import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_club_link/common/constants.dart';
import 'package:progress_club_link/common/shared_preferences.dart';
import 'package:progress_club_link/pages/splash_screen.dart';
import 'package:progress_club_link/providers/authentication_provider.dart';
import 'package:progress_club_link/providers/category_provider.dart';
import 'package:progress_club_link/providers/lead_reuquirement_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

final mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.white,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
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
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(create: (context) => LeadRequirementProvider())
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
      title: 'Progress Club',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: MaterialColor(0xff3a325f, appPrimaryColorSwatch),
        colorScheme: ColorScheme.light(
          secondary: appPrimaryColor,
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
      home: const SplashScreen(),
    );
  }
}
