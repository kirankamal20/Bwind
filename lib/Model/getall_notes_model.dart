// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetAllNotesModel {
  final String noteName;
  final String noteType;
  final String pdfUrl;

  GetAllNotesModel({
    required this.noteName,
    required this.noteType,
    required this.pdfUrl,
  });

  GetAllNotesModel copyWith({
    String? noteName,
    String? noteType,
    String? pdfUrl,
  }) {
    return GetAllNotesModel(
      noteName: noteName ?? this.noteName,
      noteType: noteType ?? this.noteType,
      pdfUrl: pdfUrl ?? this.pdfUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteName': noteName,
      'noteType': noteType,
      'pdfUrl': pdfUrl,
    };
  }

  factory GetAllNotesModel.fromMap(Map<String, dynamic> map) {
    return GetAllNotesModel(
      noteName: map['NoteName'] as String,
      noteType: map['NoteType'] as String,
      pdfUrl: map['pdfUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAllNotesModel.fromJson(String source) =>
      GetAllNotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GetAllNotesModel(NoteName: $noteName, NoteType: $noteType, pdfUrl: $pdfUrl)';

  @override
  bool operator ==(covariant GetAllNotesModel other) {
    if (identical(this, other)) return true;

    return other.noteName == noteName &&
        other.noteType == noteType &&
        other.pdfUrl == pdfUrl;
  }

  @override
  int get hashCode => noteName.hashCode ^ noteType.hashCode ^ pdfUrl.hashCode;
}
