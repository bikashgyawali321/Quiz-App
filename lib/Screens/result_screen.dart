import 'package:flutter/material.dart';
import 'package:quizapp/Screens/data/questions_list.dart';

import 'package:quizapp/main.dart';

class ResultScreen extends StatefulWidget {
  final int score;

  const ResultScreen(
      {super.key, required this.score});
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    Color maincolor = const Color(0XFF252c4a);

    return Scaffold(
      backgroundColor: maincolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Congratulations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
            width: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'You have scored',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 10,
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.score} /${questions.length * 5}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 35,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              leading: const Icon(
                Icons.reset_tv_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Go Back',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const MyApp()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
