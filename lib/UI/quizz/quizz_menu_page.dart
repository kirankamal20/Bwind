import 'dart:developer';


import 'package:distance_edu/Model/quizz_reponse_model.dart';
import 'package:distance_edu/UI/quizz/quizz_screen.dart';
import 'package:distance_edu/core/extension/context.dart';
import 'package:distance_edu/data/const/quizz_json_response.dart';
import 'package:flutter/material.dart';

class QuizzmenuPage extends StatefulWidget {
  const QuizzmenuPage({super.key});

  @override
  State<QuizzmenuPage> createState() => _QuizzmenuPageState();
}

class _QuizzmenuPageState extends State<QuizzmenuPage> {
  List<String> quizeTopic = [
    'Flutter',
    'C Programming',
    'Web Development',
    'Artificial Intelligence',
    'Java',
    'Python',
    'Data Science',
  ];
  var quizzResult = QuizzResponseModel.fromMap(quizzResponse);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Quizz Topic"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: quizeTopic.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1),
          itemBuilder: (context, index) {
            var topic = quizzResult.quizzes.map((e) => e.topic).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  var topicWiseQuestions = quizzResult.quizzes
                      .firstWhere((element) => element.topic == topic[index])
                      .questions;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizzPage(
                        topicWiseQuestions: topicWiseQuestions,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      topic[index],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
