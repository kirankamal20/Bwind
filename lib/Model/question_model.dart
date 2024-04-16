class FlutterQuizQuestion {
  final String question;
  final List<Map<String, bool>>
      options; // Each option is a map with the option string and a boolean indicating if it's correct
  FlutterQuizQuestion({
    required this.question,
    required this.options,
  });
}

class FlutterQuiz {
  static List<FlutterQuizQuestion> questions = [
    FlutterQuizQuestion(
      question:
          "What programming language is primarily used for Flutter app development?",
      options: [
        {"JavaScript": false},
        {"Dart": true},
        {"Python": false},
        {"Swift": false},
      ],
    ),
    FlutterQuizQuestion(
      question:
          "Which of the following IDEs is commonly used for Flutter development?",
      options: [
        {"Android Studio": true},
        {"Visual Studio Code": true},
        {"Xcode": true},
        {"IntelliJ IDEA": false},
      ],
    ),
    FlutterQuizQuestion(
      question: "What is the widget tree in Flutter?",
      options: [
        {
          "A tree structure of widgets that represent the layout of the app":
              true
        },
        {"A data structure used for storing widget properties": false},
        {"A tree structure of folders in the project directory": false},
        {"A type of widget used for displaying trees": false},
      ],
    ),
    FlutterQuizQuestion(
      question: "What is a StatefulWidget in Flutter?",
      options: [
        {"A widget that cannot be updated once it's built": false},
        {"A widget that holds mutable state and can be rebuilt": true},
        {"A widget that represents a fixed piece of the user interface": false},
        {"A widget that is used for handling user input": false},
      ],
    ),
    FlutterQuizQuestion(
      question:
          "What is the purpose of the pubspec.yaml file in a Flutter project?",
      options: [
        {"To specify the project's dependencies": true},
        {"To configure the app's theme": false},
        {"To define the app's layout structure": false},
        {"To declare the app's entry point": false},
      ],
    ),
    FlutterQuizQuestion(
      question:
          "Which widget is used to create a list of scrollable items in Flutter?",
      options: [
        {"Row": false},
        {"Column": false},
        {"ListView": true},
        {"GridView": false},
      ],
    ),
    FlutterQuizQuestion(
      question: "What is 'hot reload' in Flutter?",
      options: [
        {
          "The process of updating the app's code without restarting the app":
              true
        },
        {"The process of restarting the app to apply code changes": false},
        {"The process of compiling the app's code": false},
        {"The process of optimizing the app's performance": false},
      ],
    ),
    FlutterQuizQuestion(
      question:
          "Which command is used to create a new Flutter project from the command line?",
      options: [
        {"flutter init": false},
        {"flutter create": true},
        {"flutter new": false},
        {"flutter start": false},
      ],
    ),
    FlutterQuizQuestion(
      question: "What is the purpose of the 'setState' method in Flutter?",
      options: [
        {"To define the initial state of a StatefulWidget": false},
        {"To update the state of a StatefulWidget and trigger a rebuild": true},
        {"To navigate to a different screen in the app": false},
        {"To handle user input events": false},
      ],
    ),
    FlutterQuizQuestion(
      question: "What does the MaterialApp widget represent in a Flutter app?",
      options: [
        {"The main entry point of the app": false},
        {"A container for all the app's screens and widgets": false},
        {"A widget for displaying material design components": false},
        {"All of the above": true},
      ],
    ),
  ];
}
