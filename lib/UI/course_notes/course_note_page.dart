import 'package:distance_edu/Model/getall_notes_model.dart';
import 'package:distance_edu/UI/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';

class CourseNotePage extends StatefulWidget {
  final String courseName;

  final List<GetAllNotesModel> getAllNotes;
  const CourseNotePage(
      {super.key, required this.courseName, required this.getAllNotes});

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
        itemCount: widget.getAllNotes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfPageView(
                    pdfLink: widget.getAllNotes[index].pdfUrl,
                  ),
                ),
              );
            },
            child: Card(
                child: ListTile(
              title: Text(widget.getAllNotes[index].noteName),
            )),
          );
        },
      ),
    );
  }
}
