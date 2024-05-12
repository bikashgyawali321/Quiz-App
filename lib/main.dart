// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:quizapp/Screens/data/questions_list.dart';
import 'package:quizapp/Screens/questionModel.dart';
import 'package:quizapp/Screens/result_screen.dart';
import 'package:quizapp/Widgets/score_widget.dart';

void main() {
  runApp(const MyApp());
}

mixin ButtonVisibilityMixin on State<HomePage> {
  bool isButtonVisible = false;
  bool isNextButtonVisible = false;
  bool isScoreVisible = false;
  int selectedAnswerIndex =
      -1; 
  int currentIndex = -1;
  List<bool> questionAnswered = List.filled(questions.length, false);
  List<bool> questionAnsweredCorrectly = List.filled(questions.length, false);
  List<int> choosedOption = List.filled(questions.length, -1);
  List<int?> selectedOptions = List.filled(questions.length, null);
  List<int?> previousSelectedOptions = List.filled(questions.length, null);

  int score = 0;
  PageController? _controller;
  void onOptionSelected(QuestionModel questionModel, int index, bool value) {
    setState(() {
      if (!questionAnswered[index]) {
        isButtonVisible = true;
        isNextButtonVisible = false;
      }
      selectedAnswerIndex = index; 
      questionModel.userAnswer = questionModel.answers.toList()[index];
    });
  }

  void showScore(QuestionModel questionModel, int selectedOption) {
    int currentPage = _controller!.page!.toInt();

    if (!questionAnswered[currentPage]) {
      setState(() {
        if (selectedAnswerIndex == questionModel.correctAnswerIndex &&
            !questionModel.hasBeenVisited) {
          score += 5;
        }

        questionModel.hasBeenVisited = true;
        questionAnswered[currentPage] = true;
        selectedOptions[currentPage] = selectedOption;
        previousSelectedOptions[currentPage] = selectedOption;
        choosedOption[currentPage] = selectedOption;

        isNextButtonVisible = true;
        isButtonVisible = false;
      });
    }
  }

  void moveToNextQuestion() {
    currentIndex = _controller!.page!.toInt();

    if (currentIndex >= 0 && currentIndex < questions.length - 1) {

      setState(() {
        QuestionModel questionModel = questions[currentIndex];
        questionAnsweredCorrectly[currentIndex] =
            choosedOption[currentIndex] == questionModel.correctAnswerIndex;

        _controller!.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        resetButtonVisibility();
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: score ),
        ),
      );
    }

    setState(() {});
  }

  void resetButtonVisibility() {
    setState(() {
      currentIndex = -1;
      isNextButtonVisible = false;
      isButtonVisible = false;
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class _HomePageState extends State<HomePage> with ButtonVisibilityMixin {
  @override
  PageController? _controller;

  Color maincolor = const Color(0XFF252c4a);
  Color subcolor = const Color(0xFF117eeb);
  Color appbarColor = const Color.fromARGB(1234, 456, 234, 454);
  Color btncolor = const Color(0xFF117eeb);

  bool isPressed = false;
  Color isTrue = Colors.green;
  Color isFalse = Colors.red;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets play'),
        backgroundColor: appbarColor,
      ),
      backgroundColor: maincolor,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller!,
                onPageChanged: (page) {
                  setState(() {
                    isPressed = false;
                    resetButtonVisibility();
                  });
                  // }
                },
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  QuestionModel questionModel = questions[index];
                  int selectedOptionIndex = choosedOption[index];
                  bool isAnswered = questionAnswered[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScoreWidget(score),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Question ${index + 1}/${questions.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 2.0,
                        height: 8.0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        questionModel.question,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Column(
                          children: List.generate(
                        questionModel.answers.length,
                        (i) {
                          bool isSelected = selectedOptionIndex == i;
                          bool isCorrect = choosedOption[index] ==
                                  questionModel.correctAnswerIndex ||
                              choosedOption[index] != -1;
                          return Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: CheckboxListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              title: Text(
                                questionModel.answers.toList()[i],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white
                                    ),
                              ),
                              value: choosedOption[index] == i &&
                                  questionModel.userAnswer ==
                                      questionModel.answers.toList()[i],
                              onChanged: (value) {
                                setState(() {
                                  isPressed = true;
                                  isButtonVisible = true;
                                  currentIndex = i;
                                  onOptionSelected(
                                      questionModel, i, value ?? false);
                                  if (value != null && value) {
                                    choosedOption[index] = i;
                                  } else {
                                    choosedOption[index] = -1;
                                  }
                                });
                              },
                              activeColor: appbarColor,
                              controlAffinity: ListTileControlAffinity.trailing,

                              tileColor: isAnswered
                                  ? (isSelected
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : (isCorrect ? Colors.green : Colors.red))
                                  : (isSelected ? Colors.blue : Colors.blue),
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          );
                        },
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: isButtonVisible,
                        child: ElevatedButton(
                          onPressed: () {
                            if (currentIndex >= 0) {
                              setState(() {
                                showScore(questionModel, currentIndex);
                                selectedAnswerIndex =
                                    questionModel.correctAnswerIndex;
                                isNextButtonVisible = true;
                                isButtonVisible = false;
                              });
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                            width: 8,
                          ),
                          Visibility(
                              visible: isNextButtonVisible,
                              child: ElevatedButton(
                                  onPressed: () {
                                    isPressed = true;
                                    setState(() {
                                      if (index > 0) {
                                        _controller?.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeIn);
                                      }
                                    });
                                  },
                                  child: const Text('Previous Question'))),
                          const SizedBox(
                            height: 15,
                            width: 10,
                          ),
                          Visibility(
                            visible: isNextButtonVisible,
                            child: ElevatedButton(
                              onPressed: moveToNextQuestion,
                              child: Text(
                                index + 1 == questions.length
                                    ? "See Result"
                                    : "Next question",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
