import 'package:bwind/Model/AuthResponse.dart';
import 'package:bwind/Model/FireAuth.dart';
import 'package:bwind/UI/Home/HomeScreen.dart';
import 'package:bwind/UI/Login/ForgotPasswordScreen.dart';
import 'package:bwind/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  bool isLogin;
  LoginScreen({super.key, required this.isLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState(isLogin);
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  bool isLogin;
  bool? visible;
  String? titleText;
  String? buttonText;
  String? beforeLinkText;
  String? linkText;
  bool? passwordVisible;
  bool? isGoogleSigningIn;
  bool? isFacebookSigningIn;
  bool isLoging = false;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordConroller = TextEditingController();

  _LoginScreenState(this.isLogin);

  @override
  void initState() {
    if (isLogin) {
      visible = false;
      titleText = "Welcome Back!";
      beforeLinkText = "Don't have on account?";
      buttonText = "Login";
      linkText = "Sign Up";
    } else {
      visible = false;
      titleText = "Create Account!";

      beforeLinkText = "Already have an account?";
      buttonText = "Login";
      linkText = "Sign In";
    }
    isLoging = false;
    passwordVisible = false;
    isGoogleSigningIn = false;
    isFacebookSigningIn = false;
    super.initState();
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void submit() async {
    if (_loginFormKey.currentState!.validate()) {
      if (isLogin) {
        login();
      } else {
        if (_passwordController.text == _rePasswordConroller.text) {
          sighnUp();
        } else {
          Fluttertoast.showToast(
              msg: "Confirm password is not matching",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG);
        }
      }
    }
  }

  void login() async {
    FireAuth.signInUsingEmailPassword(
      isLoading: () {
        print("loading...");
        setState(() {
          isLoging = true;
        });
      },
      success: (p0) {
        navigateToHome();
        Fluttertoast.showToast(
          msg: "Successfully logged",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          isLoging = false;
        });
      },
      onError: (errorMessage) {
        print("Error: $errorMessage");
        setState(() {
          isLoging = false;
        });
        Fluttertoast.showToast(
          msg: errorMessage,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      },
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void sighnUp() async {
    FireAuth.registerUserUsingEmailPassword(
      isLoading: () {
        print("loading...");
        setState(() {
          isLoging = true;
        });
      },
      success: (p0) {
        navigateToHome();
        Fluttertoast.showToast(
          msg: "Successfully Registered",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          isLoging = false;
        });
      },
      onError: (errorMessage) {
        print("Error: $errorMessage");
        setState(() {
          isLoging = false;
        });
        Fluttertoast.showToast(
          msg: errorMessage,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
        );
      },
      email: _emailController.text,
      password: _passwordController.text,
      name: _usernameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: loginPage());
  }

  Widget loginPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 15, left: 16, right: 16),
      child: Form(
        key: _loginFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 520,
                // color: Colors.green,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              splashRadius: 25,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.black,
                                size: 30,
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 35, bottom: 5),
                        child: Text(
                          titleText!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 4),
                            child: const Text(
                              "Email",
                              style: TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: (String? value) {
                              return Validator.validateEmail(email: value!);
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD1D1D1), width: 1),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF6F30C0), width: 1),
                                ),
                                prefixIcon: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: ImageIcon(
                                    AssetImage("assets/images/email_icon.png"),
                                    color: Color(0xFF4E4E4E),
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minHeight: 22,
                                  minWidth: 22,
                                ),
                                hintText: "Email"),
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !isLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 4),
                              child: const Text(
                                "Username",
                                style: TextStyle(
                                    color: Color(0xFF4E4E4E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            TextFormField(
                              controller: _usernameController,
                              validator: (String? value) {
                                return Validator.validateUserame(
                                    username: value!);
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D1D1), width: 1),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF6F30C0), width: 1),
                                  ),
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/profile_icon.png"),
                                      color: Color(0xFF4E4E4E),
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minHeight: 22,
                                    minWidth: 22,
                                  ),
                                  hintText: "Username"),
                              style: const TextStyle(
                                  color: Color(0xFF979797),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 4),
                            child: const Text(
                              "Password",
                              style: TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 55,
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (String? value) {
                                return Validator.validatePassword(
                                    password: value!);
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D1D1), width: 1),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF6F30C0), width: 1),
                                  ),
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/password_icon.png"),
                                      color: Color(0xFF4E4E4E),
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minHeight: 22,
                                    minWidth: 22,
                                  ),
                                  suffix: IconButton(
                                    splashRadius: 12,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (passwordVisible!) {
                                        setState(() {
                                          passwordVisible = false;
                                        });
                                      } else {
                                        setState(() {
                                          passwordVisible = true;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      passwordVisible!
                                          ? CupertinoIcons.eye_fill
                                          : CupertinoIcons.eye_slash_fill,
                                      color: const Color(0xFF6F30C0),
                                    ),
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 13),
                                  ),
                                  hintText: "Password "),
                              obscureText: !passwordVisible!,
                              obscuringCharacter: '●',
                              style: const TextStyle(
                                  color: Color(0xFF979797),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Visibility(
                              visible: isLogin,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPasswordScreen()));
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Color(0xFFA069E5),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Visibility(
                        visible: !isLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 4),
                              child: const Text(
                                "Confirm Password",
                                style: TextStyle(
                                    color: Color(0xFF4E4E4E),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 55,
                              child: TextFormField(
                                controller: _rePasswordConroller,
                                validator: (String? value) {
                                  return Validator.validatePassword(
                                      password: value!);
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFD1D1D1), width: 1),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF6F30C0), width: 1),
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: ImageIcon(
                                        AssetImage(
                                            "assets/images/password_icon.png"),
                                        color: Color(0xFF4E4E4E),
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minHeight: 22,
                                      minWidth: 22,
                                    ),
                                    suffix: IconButton(
                                      onPressed: () {
                                        print("taped");
                                        if (passwordVisible!) {
                                          setState(() {
                                            passwordVisible = false;
                                          });
                                        } else {
                                          setState(() {
                                            passwordVisible = true;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        passwordVisible!
                                            ? CupertinoIcons.eye_fill
                                            : CupertinoIcons.eye_slash_fill,
                                        color: const Color(0xFF6F30C0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(),
                                    ),
                                    hintText: "Confirm Password "),
                                obscureText: !passwordVisible!,
                                obscuringCharacter: '●',
                                style: const TextStyle(
                                    color: Color(0xFF979797),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF6F30C0)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(75),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      submit();
                      // SharedPreferences preferences =
                      //     await SharedPreferences.getInstance();
                      // if (_loginFormKey.currentState!.validate()) {
                      //   FocusScope.of(context).requestFocus(FocusNode());
                      //   setState(() {
                      //     isLoging = true;
                      //   });
                      //   AuthResponse? authResponse;
                      //   if (isLogin) {
                      //     authResponse = FireAuth.signInUsingEmailPassword(
                      //         email: _emailController.text,
                      //         password: _passwordController.text);
                      //   } else {
                      //     if (_passwordController.text ==
                      //         _rePasswordConroller.text) {
                      //       authResponse =
                      //           await FireAuth.registerUserUsingEmailPassword(
                      //         name: _usernameController.text,
                      //         email: _emailController.text,
                      //         password: _passwordController.text,
                      //       );
                      //       User? user = authResponse.user;
                      //       if (user != null) {
                      //         //add display name for just created user
                      //         user.updateDisplayName(_usernameController.text);
                      //         //get updated user
                      //         await user.reload();
                      //         Fluttertoast.showToast(
                      //             msg: authResponse.msg,
                      //             gravity: ToastGravity.BOTTOM,
                      //             toastLength: Toast.LENGTH_LONG);
                      //       }
                      //     } else {
                      //       Fluttertoast.showToast(
                      //           msg: "Confirm password is not matching",
                      //           gravity: ToastGravity.BOTTOM,
                      //           toastLength: Toast.LENGTH_LONG);
                      //     }
                      //   }
                      //   setState(() {
                      //     isLoging = false;
                      //   });
                      //   if (authResponse!.code) {
                      //     await preferences.setBool("isLogedin", true);
                      //     Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const HomeScreen()));
                      //   }
                      // }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: isLoging
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isLogin ? "Login" : "Sign Up",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    child: const Text(
                      "OR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        facebookSignInButton(context),
                        const SizedBox(
                          width: 31,
                        ),
                        googleSignInButton(context),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        beforeLinkText!,
                        style: const TextStyle(
                            color: Color(0xFF979797),
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      TextButton(
                          onPressed: () {
                            if (isLogin) {
                              setState(() {
                                isLogin = false;
                                visible = false;
                                titleText = "Create Account!";
                                beforeLinkText = "Already have an account?";
                                buttonText = "Login";
                                linkText = "Sign In";
                              });
                            } else {
                              setState(() {
                                isLogin = true;
                                visible = false;
                                titleText = "Welcome Back!";
                                beforeLinkText = "Don't have on account?";
                                buttonText = "Login";
                                linkText = "Sign Up";
                              });
                            }
                          },
                          child: Text(
                            linkText!,
                            style: const TextStyle(
                                color: Color(0xFF6F30C0),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  googleSignInButton(BuildContext context) {
    if (!isGoogleSigningIn!) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 1,
              backgroundColor: Colors.white,
              minimumSize: Size.zero,
              padding: const EdgeInsets.all(10),
              shape: const CircleBorder()),
          onPressed: () async {
            setState(() {
              isGoogleSigningIn = true;
            });

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            AuthResponse response = await FireAuth.signInUsingGoogle(context);

            setState(() {
              isGoogleSigningIn = false;
            });

            Fluttertoast.showToast(
                msg: response.msg,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG);

            if (response.code) {
              await preferences.setBool("isLogedin", true);
              navigateToHome();
            }
          },
          child: const Image(
            image: AssetImage("assets/images/google_login_button_icon.png"),
            height: 40,
          ));
    } else {
      return const CircularProgressIndicator(
        color: Color(0xFF6F30C0),
      );
    }
  }

  facebookSignInButton(BuildContext context) {
    if (!isFacebookSigningIn!) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 1,
              backgroundColor: Colors.white,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              shape: const CircleBorder()),
          onPressed: () async {
            setState(() {
              isFacebookSigningIn = true;
            });
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            AuthResponse response = await FireAuth.signInUsingGoogle(context);

            setState(() {
              isFacebookSigningIn = false;
            });

            Fluttertoast.showToast(
                msg: response.msg,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG);

            if (response.code) {
              await preferences.setBool("isLogedin", true);
              navigateToHome();
            }
          },
          child: const Image(
            image: AssetImage("assets/images/facebook_login_button_icon.png"),
            height: 58,
          ));
    } else {
      return const CircularProgressIndicator(
        color: Color(0xFF6F30C0),
      );
    }
  }
}
