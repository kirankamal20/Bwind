import 'package:flutter/material.dart';

import 'CompletedCourse.dart';
import 'OngoingCourse.dart';

class MyCoursePage extends StatefulWidget{
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2 , vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      const Tab(
        text: "Ongoing",
      ),
      const Tab(
        text: "Completed",
      )
    ];

    return Padding(
      padding: const EdgeInsets.only(top:50 ,bottom:0 ,left:16,right:16 ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "My Courses",
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: TabBar(
                tabs: tabs,
              controller: _tabController,
              unselectedLabelColor: const Color(0xFFD1D1D1),
              labelColor: const Color(0xFF6F30C0),
              indicatorColor:const Color(0xFF6F30C0),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
              labelStyle: const TextStyle(
                  color: Color(0xFF6F30C0),
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
                children: const [
                  OngoingCourse(),
                  CompletedCourse()
                ]
            ),
          )
        ],
      ),
    );
  }
}