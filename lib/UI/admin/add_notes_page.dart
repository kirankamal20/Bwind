import 'dart:io';

 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distance_edu/shared/helpers/global_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({Key? key}) : super(key: key);

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> with GlobalHelper {
  String _selectedNoteType = 'B-Tech';
  final TextEditingController _noteNameController = TextEditingController();
  File? _pdfFile;
  String filename = "";
  final firebaseFirestore = FirebaseFirestore.instance;
  final collectionRefer = FirebaseFirestore.instance.collection("pdfs");
  bool isUploading = false;

  List<Map<String, dynamic>> pdfData = [];

  @override
  void initState() {
    super.initState();
  }

  String noteType(String noteName) {
    if (noteName == "B-Tech") {
      return "pdf_notes/b-tech-notes/";
    } else if (noteName == "MCA") {
      return "pdf_notes/mba-notes/";
    } else if (noteName == "MBA") {
      return "pdf_notes/mca-notes/";
    }

    return "pdf_notes/";
  }

  Future<String> uploadPdf(String fileName, File file) async {
    final reference = FirebaseStorage.instance
        .ref()
        .child("${noteType(_selectedNoteType)}$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      setState(() {
        filename = pickedFile.files[0].name;
        print(_pdfFile);
        _pdfFile = File(pickedFile.files[0].path!);
      });
    } else {
      Fluttertoast.showToast(
        msg: "Unable to SelectPdf",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void uploadNote() async {
    try {
      setState(() {
        isUploading = true;
      });
      print("pdf Uploading2...");
      final downLoadLink = await uploadPdf(filename, _pdfFile!);

      firebaseFirestore.collection("pdfs").add({
        "NoteName": _noteNameController.text,
        "NoteType": _selectedNoteType,
        "pdfUrl": downLoadLink
      });
      setState(() {
        isUploading = false;
      });
      setState(() {
        _noteNameController.clear();
        _pdfFile = null;
      });
      getAllNotes();
      print("pdf Uploaded Succesfully");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final result = await firebaseFirestore.collection("pdfs").get();

    return result.docs.map((e) => e.data()).toList();
  }

  Future<void> deleteNote(
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Note Name:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
                hintText: 'Enter note name',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note Type:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedNoteType,
              onChanged: (newValue) {
                setState(() {
                  _selectedNoteType = newValue!;
                });
              },
              items: <String>[
                'B-Tech',
                'MBA',
                'MCA',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            filename.isNotEmpty ? Text(filename) : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                pickFile();
              },
              child: const Text('Select PDF'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_pdfFile != null && _noteNameController.text.isNotEmpty) {
                  uploadNote();
                } else {
                  Fluttertoast.showToast(
                    msg: "Please select a PDF and enter a note name",
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG,
                  );
                }
              },
              child: isUploading
                  ? const Text('Uploading...')
                  : const Text('Upload Note'),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text(
              "Uploaded Notes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getAllNotes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data != null
                        ? ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Card(
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Note Name :  ${snapshot.data![index]['NoteName']}"),
                                        Text(
                                            "Note Type :   ${snapshot.data![index]['NoteType']}"),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Text("No Notes Found");
                  } else if (snapshot.hasError) {
                    return Text(" ${snapshot.error}");
                  } else {
                    return const Center(
                      child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
