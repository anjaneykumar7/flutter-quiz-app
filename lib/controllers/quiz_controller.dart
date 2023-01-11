import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/controllers/firebase_controller.dart';
import 'package:intl/intl.dart';

class QuizController extends GetxController {
  int _questionIndex = 0;
  int _optionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  var _user;

  get user => _user;
  Future<void> setUser(u) async {
    print("user saved");
    _user = u;
  }

  int get optionIndex => _optionIndex;
  int get score => _score;
  int get questionIndex => _questionIndex;
  bool get isAnswered => _isAnswered;
  bool get isCorrect => _isCorrect;
  void nextQuestion() {
    _questionIndex++;
    _optionIndex = 5;
    _isAnswered = false;
    _isCorrect = false;
    update();
  }

  void setisCorrect(v) {
    _isCorrect = v;
    update();
  }

  void updateScroe() {
    _score++;
    update();
  }

  void setIsAnswered(v) {
    _isAnswered = v;
    update();
  }

  void setCurrentInde(v) {
    _optionIndex = v;
    update();
  }

  void finishQuiz() {
    _questionIndex = 0;
    _isAnswered = false;
    _isCorrect = false;
    GetStorage storage = GetStorage();
    var email = user.email ?? "user12555@gmail.com";
    storage.write('${email}score', "$_score");

    int totalScore =
        int.parse(storage.read("${email}totalScore") ?? "0") + _score;
    storage.write('${email}previousScore', "$_score");
    storage.write('${email}totalScore', "$totalScore");

    print("previous store= ${storage.read('${email}previousScore')}");
    print("total store= ${storage.read('${email}totalScore')}");
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy ').add_jm();
    // var formatter = DateFormat.yMd().add_jm();
    String date = formatter.format(now);

    var name = user.displayName ?? "user...";

    var data = {
      "name": name,
      "score": storage.read("${email}totalScore"),
      "date": date,
    };
    FirebaseController controller = FirebaseController();
    controller.AddScore(data, email);
    _score = 0;
    update();
  }
}
