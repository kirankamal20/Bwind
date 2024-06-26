import 'package:bwind/UI/Home/PaymentOptionPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../Model/Course.dart';
import '../../Model/FireAuth.dart';
import '../../Model/Userbase.dart';
import 'ChattingPage.dart';

class CourseDetailPage extends StatefulWidget {
  Course course;
  List bookmarkedCourse;

  CourseDetailPage(
      {super.key, required this.course, required this.bookmarkedCourse});

  @override
  State<CourseDetailPage> createState() =>
      _CourseDetailPageState(course, bookmarkedCourse);
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  Course course;
  List bookmarkedCourse;

  _CourseDetailPageState(this.course, this.bookmarkedCourse);

  TabController? _tabController;
  Userbase? mentor;


  List<Tab> tabs = <Tab>[
    const Tab(
      text: "About",
    ),
    const Tab(
      text: "Lessons",
    ),
    const Tab(
      text: "Reviews",
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    getMentor();
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  getMentor() async {
    mentor = await Userbase.getCourseMentor(course.mentor!);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Userbase.updateBookmarksList(
        FireAuth.auth.currentUser!.uid, bookmarkedCourse);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 0, left: 16, right: 16),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    const Text(
                      "Course",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 0,
                      width: 35,
                    )
                  ],
                ),
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 32,
                      height: MediaQuery.of(context).size.height * 0.30,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          image: DecorationImage(
                              image: AssetImage(course.image!), fit: BoxFit.fill)),
                    ),
                    Container(
                      width: 150,
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 22),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Center(
                        child: Text(
                          course.category!,
                          style: const TextStyle(
                              color: Color(0xFF6F30C0),
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          course.courseName!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (bookmarkedCourse.contains(course.docId)) {
                            setState(() {
                              bookmarkedCourse.remove(course.docId);
                            });
                          } else {
                            setState(() {
                              bookmarkedCourse.add(course.docId);
                            });
                          }
                        },
                        icon: ImageIcon(
                          bookmarkedCourse.contains(course.docId)
                              ? const AssetImage("assets/images/bookmark_filled_icon.png")
                              : const AssetImage(
                                  "assets/images/bookmark_outlined_icon.png"),
                          color: bookmarkedCourse.contains(course.docId)
                              ? const Color(0xFF6F30C0)
                              : const Color(0xFFD1D1D1),
                          size: 26,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${course.price}",
                            style: const TextStyle(
                                color: Color(0xFF6F30C0),
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "\$${course.originalPrice}",
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: course.ratting! / 5,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 1,
                              itemSize: 23,
                              itemPadding: const EdgeInsets.only(right: 6),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(0xFFFFC90C),
                              ),
                              onRatingUpdate: (value) {},
                            ),
                            Text(
                              course.ratting.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 16,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const ImageIcon(
                            AssetImage("assets/images/peoples_icon.png"),
                            color: Color(0xFF6F30C0),
                            size: 20,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${course.enrolledStudent}Students",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          ImageIcon(
                            AssetImage("assets/images/clock_icon.png"),
                            size: 20,
                            color: Color(0xFF6F30C0),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "2.5 Hours",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          ImageIcon(
                            AssetImage("assets/images/document_icon.png"),
                            size: 20,
                            color: Color(0xFF6F30C0),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Certificate",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabs: tabs,
                  controller: _tabController,
                  unselectedLabelColor: const Color(0xFFD1D1D1),
                  labelColor: const Color(0xFF6F30C0),
                  indicatorColor: const Color(0xFF6F30C0),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                  labelStyle: const TextStyle(
                      color: Color(0xFF6F30C0),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    CourseDetailAbout(),
                    CourseDetailAbout(),
                    CourseDetailAbout()
                  ]),
                )
              ]),
            ),
          ),
        ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width - 32,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentOptionPage(course: course)));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Color(0xFF6F30C0),
                    boxShadow: [
                      BoxShadow(color: Colors.white,spreadRadius:10, blurRadius: 150, offset: Offset(0, 50))
                    ]
                  ),
                  child: Center(
                    child: Text(
                      "Enroll Course - \$${course.price}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  )),
            ),
          ),
    ]
      ),
    );
  }

  CourseDetailAbout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 22),
            child: const Text(
              "Mentor",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child:mentor==null?const SizedBox(): Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(mentor!.image.toString()),
                      radius: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mentor!.name.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            mentor!.about.toString(),
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChattingPage(receiverUser: mentor!.toMap())));
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/images/message_text_icon.png"),
                      color: Color(0xFF6F30C0),
                      size: 20,
                    ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 22, bottom: 10),
            child: const Text(
              "About Course",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: Text(
              course.about!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  color: Color(0xFF4E4E4E), fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
