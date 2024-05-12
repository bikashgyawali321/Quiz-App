class QuestionModel {
  final String question;
  List<String> answers;
  int correctAnswerIndex;
  String? userAnswer;
  //creating a constructor
  QuestionModel(this.question, this.answers, this.correctAnswerIndex,
      {this.userAnswer});

  bool hasBeenVisited = false;
}
