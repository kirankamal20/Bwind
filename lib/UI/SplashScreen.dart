import 'dart:async';

import 'package:bwind/UI/AppInfo/AppInfoScreen.dart';
import 'package:bwind/UI/Home/HomeScreen.dart';
import 'package:bwind/UI/Login/LoginOrSignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget{
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
    Future.delayed(const Duration(seconds: 3),(){
      if( preferences.getBool("isLogedin")!=null){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }else if(preferences.getBool("isFirstTime") != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginOrSignupScreen()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AppInfoScreen()));
      }
    });
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFF6F30C0),
        child: Center(
            child: Stack(
                children: [
                  Image.asset('assets/images/bwind_icon.png'),
                  Positioned(
                    top: 28,
                      child: Image.asset('assets/images/bwind_icon_box.png')
                  ),
                  Positioned(
                    left: 5,
                      child: Image.asset('assets/images/bwind_icon_arrow.png')
                  )
                ]
            )
        )
      ),
    );
  }
}