import 'package:flutter/material.dart';

class LogoutBottomSheet extends StatelessWidget {
  final Function() onTap;
  const LogoutBottomSheet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 26),
            height: 5,
            width: 50,
            decoration: const BoxDecoration(
                color: Color(0xFFD1D1D1),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            child: const Text(
              "Log Out",
              style: TextStyle(
                  color: Color(0xFFFF4141),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 38),
            child: const Text(
              "Are you sure you want to log out?",
              style: TextStyle(
                  color: Color(0xFF4E4E4E),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9F9F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(75),
                      ),
                      side: const BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 23,
              ),
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF6F30C0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(75),
                      ),
                    ),
                  ),
                  onPressed: onTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: Text(
                      "Yes, Logout",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
