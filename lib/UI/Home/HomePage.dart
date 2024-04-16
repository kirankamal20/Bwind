import 'package:bwind/Model/FireAuth.dart';
import 'package:bwind/UI/Home/HomeSearchScreen.dart';
import 'package:bwind/UI/chat/chat_page.dart';
import 'package:bwind/UI/chat/provider/chat_bot_provider.dart';
import 'package:bwind/UI/chat/provider/message_provider.dart';
import 'package:bwind/UI/quizz/quizz_screen.dart';
import 'package:bwind/core/config/type_of_bot.dart';
import 'package:bwind/data/hive/model/chat_bot/chat_bot.dart';
import 'package:bwind/shared/extension/anotted_region_ext.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../translates/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController();

  List<Map<String, String>> topMentorsList = [
    {"image": "assets/images/profile4.png", "name": "Dhyan"},
    {"image": "assets/images/profile1.png", "name": "kush"},
    {"image": "assets/images/profile2.png", "name": "Aman"},
    {"image": "assets/images/profile3.png", "name": "Tusha"},
    {"image": "assets/images/profile5.png", "name": "Nirav"},
    {"image": "assets/images/profile6.png", "name": "Bhavana"},
  ];

  List<Map<String, String>> mostPopulerCourseList = [
    {"category_name": "All", "image": "assets/images/populer_couse_image.png"},
    {"category_name": "MCA", "image": "assets/images/category1.png"},
    {"category_name": "MBA", "image": "assets/images/populer_couse_image.png"},
    {"category_name": "B-Tech", "image": "assets/images/category1.png"},
  ];

  User? _currentUser;
  int? _currentPage;
  final uuid = const Uuid();

  final bool _isBuildingChatBot = false;
  String currentState = '';

  @override
  void initState() {
    _currentUser = FireAuth.auth.currentUser;
    _currentPage = 0;
    ref.read(chatBotListProvider.notifier).fetchChatBots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dots = List.generate(
      3,
      (index) {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 5,
            width: index == _currentPage! ? 25 : 5,
            decoration: BoxDecoration(
                color: index == _currentPage!
                    ? const Color(0xFF6F30C0)
                    : const Color(0xFFCFBAE3),
                borderRadius: const BorderRadius.all(Radius.circular(50))));
      },
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 230,
            padding:
                const EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/homepage_appbar_bg.png"),
                  fit: BoxFit.cover),
              color: Color(0xFF6F30C0),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "${LocaleKeys.home_hey.tr()} ${_currentUser!.displayName}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Text(
                          "Let’s Start Learning!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        )
                      ],
                    ),
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/profile_picture.png"),
                      radius: 30,
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeSearchScreen()));
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: ImageIcon(
                                  AssetImage("assets/images/search_icon.png"),
                                  color: Color(0xFFD1D1D1),
                                ),
                              ),
                            ),
                            Text("Search Anything",
                                style: TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 11),
                          child: ImageIcon(
                            AssetImage('assets/images/filter_icon.png'),
                            size: 20,
                            color: Color(0xFF6F30C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatPage(),
                          ));
                    },
                    child: const Text("Pdf Summarize")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizzPage(),
                          ));
                    },
                    child: const Text("Quizz")),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              listTitle(LocaleKeys.home_top_mentors.tr()),
                              InkWell(
                                child: Row(
                                  children: [
                                    Text(
                                      LocaleKeys.home_view_all.tr(),
                                      style: const TextStyle(
                                          color: Color(0xFF6F30C0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/right_arrow_icon.png",
                                        ),
                                        color: Color(0xFF6F30C0),
                                        size: 19,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 90,
                          child: topMentorListView(),
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          Container(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              listTitle(
                                  LocaleKeys.home_most_popular_caurse.tr()),
                              InkWell(
                                child: Row(
                                  children: [
                                    Text(
                                      LocaleKeys.home_view_all.tr(),
                                      style: const TextStyle(
                                          color: Color(0xFF6F30C0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      child: ImageIcon(
                                        AssetImage(
                                          "assets/images/right_arrow_icon.png",
                                        ),
                                        color: Color(0xFF6F30C0),
                                        size: 19,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: mostPospularCourseListView(),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    ).anottedRegion(statusBarIconBrightness: Brightness.light);
  }

  Widget pageViewTile() {
    return Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Color(0xFFA069E5),
          image: DecorationImage(
              image: AssetImage("assets/images/home_pageview_bg design.png"),
              fit: BoxFit.cover),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "40% OFF",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    Text(
                      "Today’s Special",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    )
                  ],
                ),
                Text(
                  "40%",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 31),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get a discount for every course order!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  Text(
                    "Only valid for today!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  listTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
    );
  }

  topMentorTile(image, name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF6F30C0),
            child: CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 30,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  topMentorListView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: topMentorsList.length,
        itemBuilder: (context, index) {
          return topMentorTile(
              topMentorsList[index]['image'], topMentorsList[index]['name']);
        });
  }

  mostPopulerCourseTile(String image, String categoryName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image(
              image: AssetImage(image),
            ),
          ),
          Text(
            categoryName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          )
        ],
      ),
    );
  }

  mostPospularCourseListView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: mostPopulerCourseList.length,
        itemBuilder: (context, index) {
          return mostPopulerCourseTile(mostPopulerCourseList[index]["image"]!,
              mostPopulerCourseList[index]["category_name"]!);
        });
  }
}
