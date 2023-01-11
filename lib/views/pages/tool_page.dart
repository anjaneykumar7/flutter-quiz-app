import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/firebase_controller.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({Key? key}) : super(key: key);

  @override
  _ToolPageState createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  var firebase = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                var data = await rootBundle
                    .loadString("assets/json/question_set.json");

                List<dynamic> items = jsonDecode(data);

                for (var item in items) {
                  await Future.delayed(const Duration(milliseconds: 500));

                  var q = {
                    "question": item["question"],
                    "options": [
                      item["option1"],
                      item["option2"],
                      item["option3"],
                      item["option4"]
                    ],
                    "correctAnswerIndex": item["answer"]
                  };
                  await firebase.addQuiz(q);
                  print(item["_id"]);
                }
              },
              child: Text("Upload"))),
    );
  }
}
