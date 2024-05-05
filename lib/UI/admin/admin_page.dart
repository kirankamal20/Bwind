import 'package:bwind/UI/Login/LoginOrSignupScreen.dart';
import 'package:bwind/UI/admin/add_notes_page.dart';
import 'package:bwind/shared/widgets/custom_admin_card.dart';
import 'package:bwind/shared/widgets/logout_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrSignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          IconButton(
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutBottomSheet(onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      await preferences.remove('isAdmin');
                      navigateToLogin();
                    });
                  });
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            CustomWidgetCard(
              cardName: "Add Notes",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNotesPage(),
                  ),
                );
              },
            ),
            CustomWidgetCard(
              cardName: "Add Quizz",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
