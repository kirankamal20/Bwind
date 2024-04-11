import 'package:bwind/shared/extension/anotted_region_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CertificationPage.dart';
import 'LessonsPage.dart';

class CoursePage extends StatefulWidget {
  Map<String, dynamic> course;
  CoursePage({super.key, required this.course});

  @override
  State<CoursePage> createState() => _CoursePageState(course);
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Map<String, dynamic> course;

  _CoursePageState(this.course);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      const Tab(
        text: "Lessons",
      ),
      const Tab(
        text: "Certification",
      )
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.back)),
                Text(
                  course['course_name'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
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
                indicatorColor: const Color(0xFF6F30C0),
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                LessonsPage(
                  course: course,
                ),
                CertificationPage(
                  course: course,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
