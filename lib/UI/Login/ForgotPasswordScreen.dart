import 'package:bwind/Model/Email.dart';
import 'package:bwind/Model/EmailResponse.dart';
import 'package:bwind/UI/Login/OTPVerificationScreen.dart';
import 'package:bwind/validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotPasswordForm = GlobalKey();

  final _emailController = TextEditingController();

  bool? isSending;

  @override
  void initState() {
    // TODO: implement initState
    isSending = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 60, bottom: 38, left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      margin: const EdgeInsets.symmetric(vertical: 35),
                      child: const Image(
                        image:
                            AssetImage("assets/images/forgot_password_bg.png"),
                        height: 220,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 35, bottom: 15),
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    const Text(
                      "We need your registration email to send you password reset code.",
                      style: TextStyle(
                          color: Color(0xFF979797),
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 4),
                            child: const Text(
                              "Email",
                              style: TextStyle(
                                  color: Color(0xFF4E4E4E),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          Form(
                            key: _forgotPasswordForm,
                            child: TextFormField(
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
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                          "assets/images/email_icon.png"),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                    if (_forgotPasswordForm.currentState!.validate()) {
                      setState(() {
                        isSending = true;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                      EmailResponse emailResponse =
                          await Email.sendMail(_emailController.text);
                      setState(() {
                        isSending = false;
                      });
                      Fluttertoast.showToast(
                          msg: emailResponse.msg,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_LONG);
                      if (emailResponse.code) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTPVerificationScreen(
                                      email: _emailController.text,
                                      OTP: emailResponse.data!,
                                    )));
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: !isSending!
                        ? const Text(
                            "Send Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        : const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
