import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuizzResponseModel {
  final List<Quizze> quizzes;
  QuizzResponseModel({
    required this.quizzes,
  });

  QuizzResponseModel copyWith({
    List<Quizze>? quizzes,
  }) {
    return QuizzResponseModel(
      quizzes: quizzes ?? this.quizzes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quizzes': quizzes.map((x) => x.toMap()).toList(),
    };
  }

  factory QuizzResponseModel.fromMap(Map<String, dynamic> map) {
    return QuizzResponseModel(
      quizzes: List<Quizze>.from(
        (map['quizzes']?.map(
          (x) => Quizze.fromMap(x),
        )),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizzResponseModel.fromJson(String source) =>
      QuizzResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QuizzResponseModel(quizzes: $quizzes)';

  @override
  bool operator ==(covariant QuizzResponseModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.quizzes, quizzes);
  }

  @override
  int get hashCode => quizzes.hashCode;
}

class Quizze {
  final String topic;
  final List<Question> questions;
  Quizze({
    required this.topic,
    required this.questions,
  });

  Quizze copyWith({
    String? topic,
    List<Question>? questions,
  }) {
    return Quizze(
      topic: topic ?? this.topic,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic': topic,
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory Quizze.fromMap(Map<String, dynamic> map) {
    return Quizze(
      topic: map['topic'] as String,
      questions: List<Question>.from(
        (map['questions']?.map(
          (x) => Question.fromMap(x),
        )),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Quizze.fromJson(String source) =>
      Quizze.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Quizze(topic: $topic, questions: $questions)';

  @override
  bool operator ==(covariant Quizze other) {
    if (identical(this, other)) return true;

    return other.topic == topic && listEquals(other.questions, questions);
  }

  @override
  int get hashCode => topic.hashCode ^ questions.hashCode;
}

class Question {
  final String question;
  final List<String> options;
  final String answer;
  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  Question copyWith({
    String? question,
    List<String>? options,
    String? answer,
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'options': options,
      'answer': answer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      options: List<String>.from(
        (map['options'] as List<String>),
      ),
      answer: map['answer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Question(question: $question, options: $options, answer: $answer)';

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        listEquals(other.options, options) &&
        other.answer == answer;
  }

  @override
  int get hashCode => question.hashCode ^ options.hashCode ^ answer.hashCode;
}
