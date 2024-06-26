import 'package:bwind/Model/Course.dart';
import 'package:bwind/UI/Home/ChattingPage.dart';
import 'package:bwind/UI/Home/CourseDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';

import '../../Model/FireAuth.dart';
import '../../Model/RefreshBloc.dart';
import '../../Model/Userbase.dart';

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _searchFormKey = GlobalKey();

  final FocusNode _textFormFieldFocuseNode = FocusNode();
  List<String> recentSearchList = [];
  final _searchFieldController = TextEditingController();
  TabController? _tabController;
  List<Course>? courseList;
  List<Userbase>? mentorList;
  List<Course> searchedCourseList = [];
  List<Userbase> searchedMentorList = [];
  List bookmarkedCourse = [];
  String filtterCategory = "ALL";
  int filtterRatting = 0;
  double maxPrice = 500;
  double minPrice = 0;
  RangeValues priceRange = const RangeValues(0, 0);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getRecentSearch();
    getCourseData();
    getMentorData();
    getBookmarkList();
    _textFormFieldFocuseNode.addListener(() {
      setState(() {});
    });
    _searchFieldController.addListener(() {
      setState(() {});
    });
    filtterCategory = "ALL";
    filtterRatting = 0;
    priceRange = RangeValues(minPrice, maxPrice);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Userbase.updateBookmarksList(
        FireAuth.auth.currentUser!.uid, bookmarkedCourse);
    super.dispose();
  }

  getBookmarkList() async {
    bookmarkedCourse =
        await Userbase.getBookmarksList(FireAuth.auth.currentUser!.uid);
  }

  getMentorData() async {
    mentorList = await Userbase.getMentor();
  }

  getCourseData() async {
    courseList = await Course.getCourse();
  }

  getRecentSearch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    recentSearchList = preferences.getStringList("recentSearch")!;
  }

  addRecentSearch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList("recentSearch", recentSearchList);
  }

  searchFN(String value) {
    print(priceRange);
    setState(() {
      searchedCourseList = [];
      if (filtterCategory != "ALL" && filtterRatting != 0) {
        print("both");
        for (Course course in courseList!) {
          if (course.courseName!.toLowerCase().contains(value.toLowerCase()) &&
              course.category!.toLowerCase() == filtterCategory.toLowerCase() &&
              course.ratting! >= filtterRatting &&
              course.price! >= priceRange.start &&
              course.price! <= priceRange.end) {
            searchedCourseList.add(course);
          }
        }
      } else if (filtterCategory != "ALL") {
        print("category");
        for (Course course in courseList!) {
          if (course.courseName!.toLowerCase().contains(value.toLowerCase()) &&
              course.category!.toLowerCase() == filtterCategory.toLowerCase() &&
              course.price! >= priceRange.start &&
              course.price! <= priceRange.end) {
            searchedCourseList.add(course);
          }
        }
      } else if (filtterRatting != 0) {
        print("ratting");
        for (Course course in courseList!) {
          if (course.courseName!.toLowerCase().contains(value.toLowerCase()) &&
              course.ratting! >= filtterRatting &&
              course.price! >= priceRange.start &&
              course.price! <= priceRange.end) {
            searchedCourseList.add(course);
          }
        }
      } else {
        print("nothing");
        for (Course course in courseList!) {
          if ((course.courseName!.toLowerCase().contains(value.toLowerCase()) ||
              course.category!.toLowerCase().contains(value.toLowerCase()) )&&
                  course.price! >= priceRange.start &&
                  course.price! <= priceRange.end) {
            print(course.price! >= priceRange.start);
            searchedCourseList.add(course);
          }
        }
      }
      searchedMentorList = [];
      for (Userbase mentor in mentorList!) {
        if (mentor.name!.toLowerCase().contains(value.toLowerCase()) ||
            mentor.about!.toLowerCase().contains(value.toLowerCase())) {
          searchedMentorList.add(mentor);
        }
      }
    });
  }

  showSheet(BuildContext context) async {
    return showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        expand: false,
        context: context,
        builder: (context) => modelSheet(),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )));
  }

  List<Tab> tabs = <Tab>[
    const Tab(
      text: "Course",
    ),
    const Tab(
      text: "Mentors",
    )
  ];

  List<Map<String, dynamic>> categoryList = [
    {
      "categoryName": "ALL",
    },
    {
      "categoryName": "Design",
    },
    {
      "categoryName": "Programming",
    },
    {
      "categoryName": "Web Design",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 20, left: 16, right: 16),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - 32,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(right: 20),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Form(
                          key: _searchFormKey,
                          child: TextFormField(
                            controller: _searchFieldController,
                            textInputAction: TextInputAction.search,
                            onFieldSubmitted: (value) async {
                              if (value != "") {
                                if (recentSearchList.contains(value)) {
                                  int index = recentSearchList.indexOf(value);
                                  recentSearchList.removeAt(index);
                                }
                                recentSearchList.insert(0, value);
                                if (recentSearchList.length > 9) {
                                  recentSearchList.removeAt(5);
                                }
                                await addRecentSearch();
                                setState(() {
                                  getRecentSearch();
                                });
                              }
                            },
                            onSaved: (value) {
                              searchFN(value!);
                            },
                            onChanged: (value) {
                              searchFN(value);
                            },
                            focusNode: _textFormFieldFocuseNode,
                            autofocus: true,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1D1D1), width: 1)),
                                filled: true,
                                fillColor: const Color(0xFFF9F9F9),
                                focusColor: const Color(0xFF6F30C0),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF6F30C0), width: 1)),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ImageIcon(
                                    const AssetImage("assets/images/search_icon.png"),
                                    color: _textFormFieldFocuseNode.hasFocus
                                        ? const Color(0xFF6F30C0)
                                        : const Color(0xFF979797),
                                  ),
                                ),
                                prefixIconConstraints:
                                    const BoxConstraints(maxWidth: 45, maxHeight: 45),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                suffixIcon: IconButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                  ),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    showSheet(context);
                                  },
                                  icon: const ImageIcon(
                                    AssetImage("assets/images/filter_icon.png"),
                                    color: Color(0xFF6F30C0),
                                    size: 20,
                                  ),
                                ),
                                hintText: "Search Anything",
                                hintStyle: const TextStyle(
                                    color: Color(0xFF979797),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _searchFieldController.text != ""
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            child: TabBar(
                              controller: _tabController,
                              tabs: tabs,
                              unselectedLabelColor: const Color(0xFFD1D1D1),
                              labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              indicatorPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              indicator: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Color(0xFF6F30C0)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 14),
                            child: Divider(
                              thickness: 1,
                              color: Color(0xFFD1D1D1),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 140,
                            width: MediaQuery.of(context).size.width - 32,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  SearchedCoursePage(),
                                  SearchedMentorPage()
                                ]),
                          )
                        ],
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height - 50,
                        width: MediaQuery.of(context).size.width - 16,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    recentSearchList = [];
                                    await addRecentSearch();
                                    setState(() {
                                      getRecentSearch();
                                    });
                                  },
                                  child: const Text(
                                    "Clear all",
                                    style: TextStyle(
                                        color: Color(0xFF6F30C0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFFD1D1D1),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: recentSearchList.length,
                                    itemBuilder: (context, index) {
                                      return recentSearchListTile(index);
                                    }),
                              ),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SearchedCoursePage() {
    return searchedCourseList != []
        ? _courseListView(searchedCourseList)
        // ? Text("data")
        : const Center(
            child: Text("No results found"),
          );
  }

  _courseListView(searchedCourseList) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 18),
        itemCount: searchedCourseList.length,
        itemBuilder: (context, index) {
          return courseListTile(searchedCourseList[index]);
        });
  }

  courseListTile(course) {
    return InkWell(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CourseDetailPage(course: course, bookmarkedCourse: bookmarkedCourse)));
      },
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Image(
                    image: AssetImage(course.image),
                    height: 110,
                    width: 110,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        child: Text(
                          course.category,
                          style: const TextStyle(
                              color: Color(0xFF6F30C0),
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                course.courseName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                            Text(
                              "\$${course.price}",
                              style: const TextStyle(
                                  color: Color(0xFF6F30C0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: course.ratting / 5,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 1,
                            itemSize: 16,
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
                                color: Color(0xFF979797),
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              color: const Color(0xFFD1D1D1),
                              height: 14,
                              width: 1),
                          Text(
                            "${course.enrolledStudent} Student",
                            style: const TextStyle(
                                color: Color(0xFF979797),
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashColor: Colors.transparent,
                icon: ImageIcon(
                  const AssetImage("assets/images/bookmark_outlined_icon.png"),
                  color: bookmarkedCourse.contains(course.docId)
                      ? const Color(0xFF6F30C0)
                      : const Color(0xFFD1D1D1),
                ))
          ],
        ),
      ),
    );
  }

  SearchedMentorPage() {
    return searchedMentorList != []
        ? _MentorListView(searchedMentorList)
        : const Center(
            child: Text("No results found"),
          );
  }

  _MentorListView(searchedMentorList) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 18),
        itemCount: searchedMentorList.length,
        itemBuilder: (context, index) {
          return mentorListTile(searchedMentorList[index]);
        });
  }

  mentorListTile(Userbase mentor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(mentor.image.toString()),
                radius: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.name.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      mentor.about.toString(),
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
                            ChattingPage(receiverUser: mentor.toMap())));
              },
              icon: const ImageIcon(
                AssetImage("assets/images/message_text_icon.png"),
                color: Color(0xFF6F30C0),
                size: 20,
              ))
        ],
      ),
    );
  }

  recentSearchListTile(index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              var value = recentSearchList[index];
              setState(() {
                _searchFieldController.text = value;
                _searchFormKey.currentState!.save();
                _searchFieldController.selection =
                    TextSelection.collapsed(offset: value.length);
                recentSearchList.removeAt(index);
                recentSearchList.insert(0, value);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Text(
                recentSearchList[index],
                style: const TextStyle(
                    color: Color(0xFF979797),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
        IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              recentSearchList.removeAt(index);
              await addRecentSearch();
              setState(() {
                getRecentSearch();
              });
            },
            icon: const Icon(
              Icons.close,
              size: 18,
              color: Color(0xFF979797),
            ))
      ],
    );
  }

  filterCategoryRadioButton({required String text, required String value}) {
    return InkWell(
        onTap: () async {
          setState(() {
            filtterCategory = value;
          });
          await refreshBloc.refreshData();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 27),
          decoration: BoxDecoration(
              color:
                  filtterCategory == value ? Colors.white : const Color(0xFFF9F9F9),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              border: Border.all(
                color: filtterCategory == value
                    ? const Color(0xFF6F30C0)
                    : const Color(0xFFF9F9F9),
              )),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: filtterCategory == value
                      ? const Color(0xFF6F30C0)
                      : const Color(0xFF4E4E4E),
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
        ));
  }

  filterRattingRadioButton({required int index}) {
    List<Widget> star = [];
    for (int i = 0; i <= index; i++) {
      star.add(Icon(
        Icons.star,
        color:
            index + 1 == filtterRatting ? const Color(0xFFFFC90C) : const Color(0xFF4E4E4E),
        size: 18,
      ));
    }
    return InkWell(
        onTap: () async {
          setState(() {
            filtterRatting = index + 1;
          });
          await refreshBloc.refreshData();
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 27),
            decoration: BoxDecoration(
                color: index + 1 == filtterRatting
                    ? Colors.white
                    : const Color(0xFFF9F9F9),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                border: Border.all(
                  color: index + 1 == filtterRatting
                      ? const Color(0xFF6F30C0)
                      : const Color(0xFFF9F9F9),
                )),
            child: Row(
              children: star,
            )));
  }

  modelSheet() {
    return StreamBuilder<List<bool>>(
        stream: refreshBloc.refreshStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  height: 5,
                  width: 50,
                  decoration: const BoxDecoration(
                      color: Color(0xFFD1D1D1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  child: const Text(
                    "Filter",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 18),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            return filterCategoryRadioButton(
                                text: categoryList[index]['categoryName'],
                                value: categoryList[index]['categoryName']);
                          }),
                    )
                  ],
                )),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 38, bottom: 24),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          valueIndicatorColor: const Color(0xFF6F30C0),
                          inactiveTrackColor: const Color(0xFF6F30C0),
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.red,
                          overlayColor: const Color(0xFF6F30C0),
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 8.0),
                        ),
                        child: RangeSlider(
                          activeColor: const Color(0xFF6F30C0),
                          inactiveColor: const Color(0xFFD1D1D1),
                          values: priceRange,
                          min: 0,
                          max: 500,
                          divisions: 500 ~/ 5,
                          labels: RangeLabels(
                              "\$${priceRange.start.round()}",
                              "\$${priceRange.end.round()}"),
                          onChanged: (values) async {
                            setState(() {
                              priceRange = values;
                            });
                            await refreshBloc.refreshData();
                          },
                        ),
                      ),
                    ),
                  ],
                )),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Rating",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 53),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return filterRattingRadioButton(index: index);
                          }),
                    )
                  ],
                )),
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
                        onPressed: () async {
                          setState(() {
                            filtterCategory = "ALL";
                            filtterRatting = 0;
                            priceRange = RangeValues(minPrice, maxPrice);
                          });
                          await refreshBloc.refreshData();
                          // Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          child: Text(
                            "Reset",
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
                        onPressed: () {
                          searchFN(_searchFieldController.text);
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          child: Text(
                            "Filter",
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
        });
  }
}
