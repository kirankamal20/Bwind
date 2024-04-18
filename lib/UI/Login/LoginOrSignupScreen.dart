import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({super.key});

  @override
  State<LoginOrSignupScreen> createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  @override
  void initState() {
    setIsFirstTime();
    super.initState();
  }

  setIsFirstTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("isFirstTime", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("assets/images/login_or_signup_screen_bg.jpg"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              height: 540,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    child: OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF6F30C0)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(75),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                        isLogin: true,
                                      )));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        )),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75),
                        ),
                        side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    isLogin: false,
                                  )));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
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
