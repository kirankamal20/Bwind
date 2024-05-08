import 'package:distance_edu/UI/Home/CoursePage.dart';
import 'package:flutter/material.dart';

class CourseList extends StatefulWidget {
  List<Map<String, dynamic>> courselist;

  CourseList({super.key, required this.courselist});

  @override
  State<CourseList> createState() => _CourseListState(courselist);
}

class _CourseListState extends State<CourseList> {
  List<Map<String, dynamic>> courselist;
  _CourseListState(this.courselist);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.transparent,
            Colors.white
          ],
          stops: [
            0.0,
            0.1,
            0.85,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 14),
          itemCount: courselist.length,
          itemBuilder: (context, index) {
            return CourseListTile(
                courselist[index],
                courselist[index]['image'],
                courselist[index]['course_name'],
                courselist[index]['duration'],
                courselist[index]['conpleted']);
          }),
    );
  }

  CourseListTile(course, image, courseName, duration, completed) {
    Color? progressColor;
    if (completed <= 40) {
      progressColor = const Color(0xFFE13333);
    } else if (completed <= 50) {
      progressColor = const Color(0xFF6cd2a8);
    } else if (completed <= 60) {
      progressColor = const Color(0xFF1D2EC5);
    } else if (completed <= 80) {
      progressColor = const Color(0xFFFFC90C);
    } else if (completed <= 100) {
      progressColor = const Color(0xFF6F30C0);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoursePage(course: course)));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image(
                      image: AssetImage(image),
                      height: 110,
                      width: 110,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            courseName,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          duration,
                          style: const TextStyle(
                              color: Color(0xFF979797),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Stack(alignment: AlignmentDirectional.center, children: [
                SizedBox(
                  height: 75,
                  width: 75,
                  child: CircularProgressIndicator(
                    value: completed.toDouble() / 100,
                    color: progressColor,
                    backgroundColor: const Color(0xFFd1d1d1),
                    strokeWidth: 5.5,
                  ),
                ),
                Text(
                  "${completed.toInt()}%",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
