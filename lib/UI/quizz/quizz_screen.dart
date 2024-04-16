import 'dart:async';

import 'package:bwind/Model/question_model.dart';
import 'package:bwind/core/extension/context.dart';
import 'package:bwind/shared/helpers/global_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum StudentPassStatus {
  passed,
  failed,
}

class QuizzPage extends StatefulWidget {
  const QuizzPage({Key? key}) : super(key: key);

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> with GlobalHelper {
  int questionNumber = 0;
  int score = 0;
  double scorePercentage = 0.0;
  int optionsIndex = -1;
  final List<FlutterQuizQuestion> questions = FlutterQuiz.questions;
  int counter = 30;
  List<String> leadingOptions = ["A", "B", "C", "D"];
  Timer? timer;
  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  void nextQuestions(Map<String, bool>? option) {
    if (optionsIndex == -1 && option != null) {
      showSelectOptionDialog(
        tittle: "Alert",
        subtittle: "Please select one option",
      );
      return;
    }

    setState(() {
      if (isCheckQuestionEnded()) {
        counter = 30;
        questionNumber++;
        optionsIndex = -1;
        if (option != null && option.containsValue(true)) {
          score++;
        }
      }
    });
  }

  StudentPassStatus passPercentageStatus() {
    final double percentage = score * 100 / questions.length;
    return percentage > 70
        ? StudentPassStatus.passed
        : StudentPassStatus.failed;
  }

  void submitAnswer() {
    final status = passPercentageStatus();
    showSelectOptionDialog(
      tittle: status == StudentPassStatus.passed
          ? "Your Test is Passed"
          : "Your Test is Failed",
      subtittle: "Your Score is $score / ${questions.length}",
    );
  }

  bool isCheckQuestionEnded() {
    return questionNumber < questions.length - 1;
  }

  bool isLastQuestion() {
    return questionNumber == questions.length - 1;
  }

  void onTapOption(int index, Map<String, bool> option) {
    setState(() {
      optionsIndex = index;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => nextQuestions(option),
    );
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer1) {
      setState(() {
        counter--;
      });
      if (counter == 0) {
        timer1.cancel();
        if (!isLastQuestion()) {
          nextQuestions(null);
          counter = 30;
          startCountdown();
        } else {
          submitAnswer();
          timer1.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        actions: [
          Text(
            "${questionNumber + 1} / ${questions.length}",
            style: const TextStyle(fontSize: 17, color: Colors.white),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 30,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(children: [
                const Icon(
                  Icons.timelapse,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  "$counter s",
                  style: const TextStyle(fontSize: 14),
                ),
              ]),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                questions[questionNumber].question,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                itemCount: questions[questionNumber].options.length,
                itemBuilder: (context, index) {
                  final option = questions[questionNumber].options[index];

                  return GestureDetector(
                    onTap: () => onTapOption(index, option),
                    child: Card(
                      color: optionsIndex == index
                          ? context.colorScheme.inverseSurface
                          : null,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Text(
                          "${leadingOptions[index]} )",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: optionsIndex == index
                                ? Colors.white
                                : context.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          option.keys.first,
                          style: TextStyle(
                            color: optionsIndex == index
                                ? Colors.white
                                : context.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // isCheckQuestionEnded() ? nextQuestions() :

                isLastQuestion() ? submitAnswer() : null;
              },
              child: Text(isCheckQuestionEnded() ? "Next" : "Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
