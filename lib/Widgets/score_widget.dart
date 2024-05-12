import 'package:flutter/material.dart';

class ScoreWidget extends StatefulWidget {
  final int score;

  const ScoreWidget(this.score, {super.key});

  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(bottom: 178, left: 55),
      child: Text(
        "Score: ${widget.score}",
        style: const TextStyle(color: Colors.white, fontSize: 28),
      ),
    );
  }
}
