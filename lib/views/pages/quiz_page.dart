import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/views/pages/score_page.dart';
import '../../controllers/firebase_controller.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var pageController = PageController(initialPage: 0);
  var firebaseController = Get.find<FirebaseController>();
  var quizController = Get.find<QuizController>();
  @override
  void dispose() {
    // TODO: implement dispose
    // firebaseController.dispose();
    // quizController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseController.getQuiz20();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(builder: (quizController) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: appColor.shade600,
            title: const Text('Quiz App'),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Text(
                    "${quizController.questionIndex + 1} / ${firebaseController.quiz_limit}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: GetBuilder<FirebaseController>(builder: (controller) {
            return PageView.builder(
                controller: pageController,
                itemCount: controller.quizez20.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var doc = controller.quizez20.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "${index + 1}. ${doc['question']}",
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        h20,
                        IgnorePointer(
                          ignoring: quizController.isAnswered,
                          child: Column(
                            children: [
                              ...List.generate(
                                4,
                                (i) => GestureDetector(
                                  onTap: () async {
                                    quizController.setIsAnswered(true);

                                    quizController.setCurrentInde(i + 1);

                                    if (doc["correctAnswerIndex"] == (i + 1)) {
                                      quizController.updateScroe();
                                      showToast("correct answer", Colors.green);
                                    } else {
                                      showToast("wrong answer", Colors.red);
                                    }

                                    if (quizController.isAnswered) {
                                      if (kDebugMode) {
                                        if (firebaseController.quiz_limit ==
                                            (index + 1)) {
                                          // quizController.finishQuiz();
                                          // Get.to(() => const ScorePage());
                                        }
                                      }
                                    }
                                  },
                                  child: !quizController.isAnswered
                                      ? buildOption(
                                          "${doc['options'].elementAt(i)}",
                                          (i + 1),
                                          2)
                                      : (i + 1) == doc["correctAnswerIndex"]
                                          ? buildOption(
                                              "${doc['options'].elementAt(i)}",
                                              (i + 1),
                                              1)
                                          : buildOption(
                                              "${doc['options'].elementAt(i)}",
                                              (i + 1),
                                              0),
                                ),
                              ).toList(),
                            ],
                          ),
                        ),
                        h20,
                        h10,
                        IgnorePointer(
                          ignoring: !quizController.isAnswered,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (quizController.isAnswered) {
                                // GetStorage box = GetStorage();
                                // print(box.read("scrore"));
                                if (quizController.questionIndex <
                                    firebaseController.quiz_limit - 1) {
                                  quizController.nextQuestion();
                                  pageController
                                      .jumpToPage(quizController.questionIndex);
                                } else {
                                  quizController.finishQuiz();
                                  Get.to(() => ScorePage(
                                        email: quizController.user.email,
                                      ));
                                }
                              } else {
                                showToast("please select answer ", Colors.red);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                quizController.questionIndex <
                                        firebaseController.quiz_limit - 1
                                    ? "Next "
                                    : "Finish",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }),
        ),
      );
    });
  }

  checkAnswer(doc, anst) {
    if (doc["correctAnswerIndex"] == anst) {
      true;
    } else {
      false;
    }
  }

  buildOption(text, letter, i) {
    var color = Colors.white;
    switch (i) {
      case 1:
        color = Colors.green.shade100;
        break;
      case 2:
        color = Colors.white;
        break;
      case 0:
        color = Colors.red.shade200;
        break;
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        // color: quizController.isAnswered
        //     ? quizController.isCorrect
        //         ? Colors.green.shade100
        //         : Colors.red.shade100
        //     : Colors.white,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    // color: Colors.blue,
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    // borderRadius: BorderRadius.circular(25),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "$letter",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: (Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 3,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showToast(msg, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
