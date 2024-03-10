import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LessonsPage extends StatefulWidget{
  Map<String, dynamic> course;
  LessonsPage({super.key, required this.course});

  @override
  State<LessonsPage> createState() => _LessonsPageState(course);
}

class _LessonsPageState extends State<LessonsPage>{
  Map<String, dynamic> course;
  _LessonsPageState(this.course);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Lessons"),
    );
  }

}