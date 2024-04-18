import 'package:bwind/UI/chat/chat_page.dart';
import 'package:bwind/shared/extension/anotted_region_ext.dart';
import 'package:flutter/material.dart';

import 'BookMarkPage.dart';
import 'HomePage.dart';
import 'InboxPage.dart';
import 'MyCoursePage.dart';
import 'ProfilePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          _activeIndex = tabController.index;
        });
      }
    });

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 17, left: 16, right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                    icon: ImageIcon(AssetImage(_activeIndex != 0
                        ? "assets/images/home_outlined_icon.png"
                        : "assets/images/home_filled_icon.png"))),
                Tab(
                    icon: ImageIcon(AssetImage(_activeIndex != 1
                        ? "assets/images/play_outlined_icon.png"
                        : "assets/images/play_filled_icon.png"))),
                Tab(
                    icon: ImageIcon(AssetImage(_activeIndex != 2
                        ? "assets/images/bookmark_outlined_icon.png"
                        : "assets/images/bookmark_filled_icon.png"))),
                Tab(
                    icon: ImageIcon(AssetImage(_activeIndex != 3
                        ? "assets/images/message_outlined_icon.png"
                        : "assets/images/message_filled_icon.png"))),
                Tab(
                    icon: ImageIcon(AssetImage(_activeIndex != 4
                        ? "assets/images/profile_outlined_icon.png"
                        : "assets/images/profile_filled_icon.png"))),
              ],
              indicatorColor: const Color(0xFF6F30C0),
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 25),
              unselectedLabelColor: const Color(0xFFD1D1D1),
              labelColor: const Color(0xFF6F30C0),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const HomePage(),
            const MyCoursePage().anottedRegion(),
            const ChatPage().anottedRegion(),
            const InboxPage().anottedRegion(),
            const ProfilePage().anottedRegion()
          ],
        ),
      ),
    );
  }
}
