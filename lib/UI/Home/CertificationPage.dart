import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CertificationPage extends StatefulWidget{
  Map<String, dynamic> course;
  CertificationPage({super.key, required this.course});

  @override
  State<CertificationPage> createState() => _CertificationPageState(course);
}

class _CertificationPageState extends State<CertificationPage>{
  Map<String, dynamic> course;
  _CertificationPageState(this.course);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Certification"),
    );
  }

}