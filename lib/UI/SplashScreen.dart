import 'dart:async';

import 'package:distance_edu/UI/AppInfo/AppInfoScreen.dart';
import 'package:distance_edu/UI/Home/HomeScreen.dart';
import 'package:distance_edu/UI/Login/LoginOrSignupScreen.dart';
import 'package:distance_edu/UI/admin/admin_page.dart';
import 'package:distance_edu/shared/extension/anotted_region_ext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    checkLoginFN();
    super.initState();
  }

  checkLoginFN() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 3), () {
      if (preferences.getBool("isLogedin") != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (preferences.getBool("isFirstTime") != null) {
        if (preferences.getBool("isAdmin") != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminPage()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginOrSignupScreen()));
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AppInfoScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/app_logo.jpg',
            height: 300,
            width: 200,
          ),

          // Stack(
          //     children: [
          //       Image.asset('assets/images/app_logo.jpg'),
          //       Positioned(
          //         top: 28,
          //           child: Image.asset('assets/images/bwind_icon_box.png')
          //       ),
          //       Positioned(
          //         left: 5,
          //           child: Image.asset('assets/images/bwind_icon_arrow.png')
          //       )
          //     ]
          // )
        ),
      ).anottedRegion(),
    );
  }
}
