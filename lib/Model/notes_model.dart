// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:convert';

import 'package:flutter/foundation.dart';

class NoteModel {
  final List<Note> notes;
  NoteModel({
    required this.notes,
  });

  NoteModel copyWith({
    List<Note>? notes,
  }) {
    return NoteModel(
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      notes: List<Note>.from(
        (map['notes']?.map((x) => Note.fromMap(x))),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NoteModel(notes: $notes)';

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.notes, notes);
  }

  @override
  int get hashCode => notes.hashCode;
}

class Note {
  final String course_name;
  final List<Course_note> course_notes;
  Note({
    required this.course_name,
    required this.course_notes,
  });

  Note copyWith({
    String? course_name,
    List<Course_note>? course_notes,
  }) {
    return Note(
      course_name: course_name ?? this.course_name,
      course_notes: course_notes ?? this.course_notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'course_name': course_name,
      'course_notes': course_notes.map((x) => x.toMap()).toList(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      course_name: map['course_name'] as String,
      course_notes: List<Course_note>.from(
        (map['course_notes']?.map((x) => Course_note.fromMap(x))),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Note(course_name: $course_name, course_notes: $course_notes)';

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;

    return other.course_name == course_name &&
        listEquals(other.course_notes, course_notes);
  }

  @override
  int get hashCode => course_name.hashCode ^ course_notes.hashCode;
}

class Course_note {
  final String note_name;
  final String pdf_urls;
  Course_note({
    required this.note_name,
    required this.pdf_urls,
  });

  Course_note copyWith({
    String? note_name,
    String? pdf_urls,
  }) {
    return Course_note(
      note_name: note_name ?? this.note_name,
      pdf_urls: pdf_urls ?? this.pdf_urls,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'note_name': note_name,
      'pdf_urls': pdf_urls,
    };
  }

  factory Course_note.fromMap(Map<String, dynamic> map) {
    return Course_note(
      note_name: map['note_name'] as String,
      pdf_urls: map['pdf_urls'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course_note.fromJson(String source) =>
      Course_note.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Course_note(note_name: $note_name, pdf_urls: $pdf_urls)';

  @override
  bool operator ==(covariant Course_note other) {
    if (identical(this, other)) return true;

    return other.note_name == note_name && other.pdf_urls == pdf_urls;
  }

  @override
  int get hashCode => note_name.hashCode ^ pdf_urls.hashCode;
}
