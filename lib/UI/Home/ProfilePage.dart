import 'package:distance_edu/Model/AuthResponse.dart';
import 'package:distance_edu/Model/FireAuth.dart';
import 'package:distance_edu/UI/Home/EditProfilePage.dart';
import 'package:distance_edu/UI/Home/HelpCenterPage.dart';
import 'package:distance_edu/UI/Home/InviteFriendPage.dart';
import 'package:distance_edu/UI/Home/LanguagePage.dart';
import 'package:distance_edu/UI/Home/NotificationPage.dart';
import 'package:distance_edu/UI/Home/PaymentOptionSettingPage.dart';
import 'package:distance_edu/UI/Home/PrivacyPolicyPage.dart';
import 'package:distance_edu/UI/Home/SecurityPage.dart';
import 'package:distance_edu/UI/Login/LoginOrSignupScreen.dart';
import 'package:distance_edu/shared/widgets/logout_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;

  @override
  void initState() {
    _currentUser = FireAuth.auth.currentUser;
    super.initState();
  }

  getCurrentUser() {}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 55, bottom: 0, left: 16, right: 16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                              color: Color(0xFFF9F9F9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/profile_picture.png"),
                                    radius: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _currentUser?.displayName ??
                                                "Name not available",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            _currentUser?.email ??
                                                "Email not available",
                                            style: const TextStyle(
                                                color: Color(0xFF979797),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const ImageIcon(
                                AssetImage("assets/images/arrow_right.png"),
                                color: Colors.black,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    profileTile("assets/images/notification_icon.png",
                        const Color(0xFF6F30C0), "Notification", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()));
                    }),
                    profileTile("assets/images/add_card_icon.png",
                        const Color(0xFF6F30C0), "Payment", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentOptionSettingPage()));
                    }),
                    profileTile("assets/images/shield_icon.png",
                        const Color(0xFF6F30C0), "Security", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecurityPage()));
                    }),
                    profileTile("assets/images/language_icon.png",
                        const Color(0xFF6F30C0), "Language", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LanguagePage()));
                    }),
                    profileTile("assets/images/notification_icon.png",
                        const Color(0xFF6F30C0), "Privacy Policy", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage()));
                    }),
                    profileTile("assets/images/info_icon.png",
                        const Color(0xFF6F30C0), "Help Center", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpCenterPage()));
                    }),
                    profileTile("assets/images/peoples_icon.png",
                        const Color(0xFF6F30C0), "Invite Friends", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InviteFriendPage()));
                    }),
                    profileTile("assets/images/logout_icon.png",
                        const Color(0xFFFF0000), "Logout", () {
                      showMaterialModalBottomSheet(
                        backgroundColor: Colors.white,
                        expand: false,
                        context: context,
                        builder: (context) =>
                            LogoutBottomSheet(onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          AuthResponse response = await FireAuth.signOut();
                          Fluttertoast.showToast(
                              msg: response.msg,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM);
                          if (response.code) {
                            await preferences.remove('isLogedin');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginOrSignupScreen()));
                          }
                        }),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  profileTile(iconImage, color, title, Function()? ontap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: ontap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ImageIcon(
                    AssetImage(iconImage),
                    color: color,
                    size: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const ImageIcon(
                AssetImage("assets/images/arrow_right.png"),
                color: Colors.black,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
