

class RootData {
  List<Question>? questions;

  RootData({this.questions});

  RootData.fromJson(Map<String, dynamic> json) {
    if (json['question'] != null) {
      questions = <Question>[];
      json['question'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }
}

class Question {
  String? question;
  List<String>? answers;
  int? right;

  Question({this.question, this.answers, this.right});

  Question.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = json['answers'].cast<String>();
    right = json['right'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answers'] = this.answers;
    data['right'] = this.right;
    return data;
  }
}