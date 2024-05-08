import 'dart:async';
import 'dart:developer';

 
import 'package:distance_edu/Model/quizz_reponse_model.dart';
import 'package:distance_edu/core/extension/context.dart';
import 'package:distance_edu/shared/helpers/global_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum StudentPassStatus {
  passed,
  failed,
}

class QuizzPage extends StatefulWidget {
  final List<Question> topicWiseQuestions;
  const QuizzPage({Key? key, required this.topicWiseQuestions})
      : super(key: key);

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> with GlobalHelper {
  int questionNumber = 0;
  int score = 0;
  double scorePercentage = 0.0;
  int optionsIndex = -1;

  int counter = 30;
  List<String> leadingOptions = ["A", "B", "C", "D"];
  Timer? timer;
  @override
  void initState() {
    startCountdown();
    super.initState();
  }

  void nextQuestions(Question? question, String selectedAnswer) {
    log("length of questions ${widget.topicWiseQuestions.length}");
    log("Answer ${question?.answer.toString()}");
    log("Selected Answer $selectedAnswer");
    log("Question number: $questionNumber");

    if (optionsIndex == -1 && question != null && selectedAnswer.isNotEmpty) {
      showSelectOptionDialog(
        tittle: "Alert",
        subtittle: "Please select one option",
      );
      return;
    }

    if (isCheckQuestionEnded()) {
      print("Question Ended");

      // Check if the selected answer is correct for the last question
      if (question != null &&
          question.answer.contains(selectedAnswer) &&
          selectedAnswer.isNotEmpty) {
        score++;
      }
    } else {
      counter = 30;
      optionsIndex = -1;
      questionNumber++;

      // Check if the selected answer is correct
      if (question != null &&
          question.answer.contains(selectedAnswer) &&
          selectedAnswer.isNotEmpty) {
        score++;
      }

      setState(() {});
    }
  }

  bool isCheckQuestionEnded() {
    return questionNumber >= widget.topicWiseQuestions.length - 1;
  }

  StudentPassStatus passPercentageStatus() {
    final double percentage = score * 100 / widget.topicWiseQuestions.length;
    return percentage > 70
        ? StudentPassStatus.passed
        : StudentPassStatus.failed;
  }

  void submitAnswer() {
    final status = passPercentageStatus();
    if (!isDialogisOpen()) {
      showSelectOptionDialog(
        tittle: status == StudentPassStatus.passed
            ? "Your Test is Passed"
            : "Your Test is Failed",
        subtittle: "Your Score is $score / ${widget.topicWiseQuestions.length}",
      );
    }
  }

  bool isLastQuestion() {
    return questionNumber == widget.topicWiseQuestions.length - 1;
  }

  void onTapOption(int index, Question question, String selectedAnswer) {
    setState(() {
      optionsIndex = index;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => nextQuestions(question, selectedAnswer),
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
          nextQuestions(null, '');
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
            "${questionNumber + 1} / ${widget.topicWiseQuestions.length}",
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
                widget.topicWiseQuestions[questionNumber].question,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                itemCount:
                    widget.topicWiseQuestions[questionNumber].options.length,
                itemBuilder: (context, index) {
                  final qustionAnswerOptions =
                      widget.topicWiseQuestions[questionNumber].options[index];

                  final question = widget.topicWiseQuestions[questionNumber];
                  final selectedAnswer =
                      widget.topicWiseQuestions[questionNumber].options[index];
                  return GestureDetector(
                    onTap: () {
                      onTapOption(index, question, selectedAnswer);
                    },
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
                          qustionAnswerOptions,
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
              child: Text(isCheckQuestionEnded() ? "Submit" : "Next"),
            ),
          ],
        ),
      ),
    );
  }
}
