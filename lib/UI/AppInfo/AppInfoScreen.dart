import 'package:flutter/material.dart';

import '../Login/LoginOrSignupScreen.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({super.key});

  @override
  State<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  List<Map<String, dynamic>> appInfoList = [
    {
      'image': 'assets/images/appinfo_first.jpg',
      'title': 'Teaching',
      'description':
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
    },
    {
      'image': 'assets/images/appinfo_second.jpg',
      'title': 'Teaching',
      'description':
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
    },
    {
      'image': 'assets/images/appinfo_third.png',
      'title': 'Teaching',
      'description':
          "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable."
    }
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = 0;
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
            width: index == _currentPage? 25 : 5,
            decoration: BoxDecoration(
                color: index == _currentPage? const Color(0xFF6F30C0) : const Color(0xFFCFBAE3),
                borderRadius: const BorderRadius.all(Radius.circular(50))));
      },
    );


    infoPage(image, title, description,) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.fill
              )
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
          ),
          Container(
            margin: const EdgeInsets.only(top: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dots,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 28),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 1.7,
                          fontSize: 14,
                          color: Color(0xFF979797),
                          fontWeight: FontWeight.w400),
                    ),
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
                      onPressed: () {
                        if (_currentPage == appInfoList.length-1) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginOrSignupScreen()));
                          return;
                        } else {
                          setState(() {
                            _currentPage = _currentPage + 1;
                            _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
                          });
                          return;
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      );
    }


    return Scaffold(
        body: PageView.builder(
          controller: _pageController,
            itemCount: appInfoList.length,
            onPageChanged: (int page){
            setState(() {
              _currentPage = page;
            });
            },
            itemBuilder: (context, index){
              return infoPage(appInfoList[index]['image'], appInfoList[index]['title'], appInfoList[index]['description']);
            }
        )
    );
  }
}
