import 'package:bwind/Model/notes_model.dart';
import 'package:bwind/UI/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';

class CourseNotePage extends StatefulWidget {
  final String courseName;
  final List<Course_note> courseWiseNotes;
  const CourseNotePage(
      {super.key, required this.courseName, required this.courseWiseNotes});

  @override
  State<CourseNotePage> createState() => _CourseNotePageState();
}

class _CourseNotePageState extends State<CourseNotePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.courseName} Note"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: widget.courseWiseNotes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfPageView(
                    pdfLink: widget.courseWiseNotes[index].pdf_urls,
                  ),
                ),
              );
            },
            child: Card(
                child: ListTile(
              title: Text(widget.courseWiseNotes[index].note_name),
            )),
          );
        },
      ),
    );
  }
}
