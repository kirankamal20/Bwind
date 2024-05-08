 
import 'package:distance_edu/Model/FireAuth.dart';
import 'package:distance_edu/Model/Userbase.dart';
import 'package:distance_edu/UI/Login/ResetPasswordScreen.dart';
import 'package:distance_edu/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/Email.dart';
import '../../Model/EmailResponse.dart';

class OTPVerificationScreen extends StatefulWidget {
  String email;
  String OTP;
  OTPVerificationScreen({super.key, required this.email, required this.OTP});

  @override
  State<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState(email, OTP);
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<bool>? isFilled;
  String OTP;
  String email;
  _OTPVerificationScreenState(this.email, this.OTP);
  final GlobalKey<FormState> _otpFormKey = GlobalKey();

  final _firstDigitOTPController = TextEditingController();
  final _secondDigitOTPController = TextEditingController();
  final _thirdigitOTPController = TextEditingController();
  final _fourthDigitOTPController = TextEditingController();
  final _fifthigitOTPController = TextEditingController();
  final _sixthDigitOTPController = TextEditingController();

  bool? isVerifying;
  @override
  void initState() {
    isVerifying = false;
    isFilled = [false, false, false, false, false, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                              AssetImage("assets/images/verification_bg.png"),
                          height: 220,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 35, bottom: 15),
                        child: const Text(
                          "Verification!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins"),
                        ),
                      ),
                      Text(
                        "We sent you a verification code to your email $email",
                        style: const TextStyle(
                            color: Color(0xFF979797),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Form(
                        key: _otpFormKey,
                        child: Container(
                            margin: const EdgeInsets.only(top: 70),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OTPTextField(0, _firstDigitOTPController, size),
                                const SizedBox(
                                  width: 13,
                                ),
                                OTPTextField(
                                    1, _secondDigitOTPController, size),
                                const SizedBox(
                                  width: 13,
                                ),
                                OTPTextField(2, _thirdigitOTPController, size),
                                const SizedBox(
                                  width: 13,
                                ),
                                OTPTextField(
                                    3, _fourthDigitOTPController, size),
                                const SizedBox(
                                  width: 13,
                                ),
                                OTPTextField(4, _fifthigitOTPController, size),
                                const SizedBox(
                                  width: 13,
                                ),
                                OTPTextField(5, _sixthDigitOTPController, size),
                              ],
                            )),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF6F30C0)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_otpFormKey.currentState!.validate()) {
                                if (Validator.isEmptyOTP(
                                    _firstDigitOTPController.text,
                                    _secondDigitOTPController.text,
                                    _thirdigitOTPController.text,
                                    _fourthDigitOTPController.text,
                                    _fifthigitOTPController.text,
                                    _sixthDigitOTPController.text)) {
                                  Fluttertoast.showToast(
                                      msg: "Fill Every Digit",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG);
                                } else {
                                  _otpFormKey.currentState!.reset();
                                  setState(() {
                                    isVerifying = true;
                                  });
                                  String receivedOTP =
                                      _firstDigitOTPController.text +
                                          _secondDigitOTPController.text +
                                          _thirdigitOTPController.text +
                                          _fourthDigitOTPController.text +
                                          _fifthigitOTPController.text +
                                          _sixthDigitOTPController.text;
                                  print(receivedOTP);
                                  bool verifyStatus = OTP == receivedOTP;

                                  if (verifyStatus) {
                                    Userbase userBase =
                                        await Userbase.getUserBaseByEmail(
                                            email);
                                    FireAuth.signInUsingEmailPassword(
                                        isLoading: () {},
                                        onError: (p0) {},
                                        success: (p0) {},
                                        email: userBase.email!,
                                        password: userBase.password!);
                                    setState(() {
                                      isVerifying = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Verified",
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_LONG);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetPasswordScreen()));
                                  } else {
                                    setState(() {
                                      isVerifying = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: "Invalid OTP",
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: !isVerifying!
                                  ? const Text(
                                      "Verify",
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
                                      )),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn’t receive a code?",
                              style: TextStyle(
                                  color: Color(0xFF979797),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            TextButton(
                                onPressed: () async {
                                  Fluttertoast.showToast(
                                      msg: "Sending...",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG);
                                  EmailResponse emailResponse =
                                      await Email.sendMail(email);
                                  Fluttertoast.showToast(
                                      msg: emailResponse.msg,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG);
                                  if (emailResponse.code) {
                                    OTP = emailResponse.data!;
                                  }
                                },
                                child: const Text(
                                  "Resend Code",
                                  style: TextStyle(
                                      color: Color(0xFF6F30C0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  OTPTextField(int index, TextEditingController controller, Size size) {
    return SizedBox(
      height: 46,
      width: size.width * 0.12,
      child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        TextFormField(
          controller: controller,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFD1D1D1), width: 1),
            ),
            contentPadding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 4, right: 0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFF6F30C0), width: 1),
            ),
          ),
          maxLength: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
              setState(() {
                isFilled![index] = false;
              });
            } else {
              FocusScope.of(context).nextFocus();
              setState(() {
                isFilled![index] = true;
              });
            }
          },
        ),
        Positioned(
          child: Container(
            height: 5,
            decoration: BoxDecoration(
                color: isFilled![index]
                    ? const Color(0xFF6F30C0)
                    : const Color(0xFFD1D1D1),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
          ),
        )
      ]),
    );
  }
}
