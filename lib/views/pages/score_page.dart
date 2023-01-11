import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/views/pages/auth_gate.dart';

import 'package:quiz_app/views/pages/quiz_page.dart';

class ScorePage extends StatefulWidget {
  ScorePage({Key? key, required this.email}) : super(key: key);
  String email;

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade400,
                Colors.amber.shade300,
              ],
            ),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              h20,
              h20,
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: [
                        Text(
                            "Your score is ${storage.read("${widget.email}score")}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700)),
                        h20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Get.offAll(() => const QuizPage());
                                },
                                child: const Text("Restart")),
                            w20,
                            ElevatedButton(
                                onPressed: () {
                                  Get.offAll(() => const AuthGate());
                                },
                                child: const Text("Home"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      );
    });
  }
}
