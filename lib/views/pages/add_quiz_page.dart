import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/views/pages/quiz_list_page.dart';
import '../../controllers/firebase_controller.dart';

class AddQuizPage extends StatefulWidget {
  const AddQuizPage({Key? key}) : super(key: key);

  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  var questionController = TextEditingController();
  var optionController1 = TextEditingController();
  var optionController2 = TextEditingController();
  var optionController3 = TextEditingController();
  var optionController4 = TextEditingController();

  var firebase = Get.find<FirebaseController>();
  var isSelected = [false, false, false, false];
  final formGlobalKey = GlobalKey<FormState>();
  int correctAnswerIndex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    questionController.dispose();
    optionController1.dispose();
    optionController2.dispose();
    optionController3.dispose();
    optionController4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Get.to(() => QuizListPage());
                },
                icon: const Icon(
                  Icons.list_alt_outlined,
                  size: 30,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formGlobalKey,
          child: ListView(
            children: [
              buildInput("Enter Question", questionController, "Q"),
              buildInput("Enter Option 1", optionController1, "1"),
              buildInput("Enter Option 2", optionController2, "2"),
              buildInput("Enter Option 3", optionController3, "3"),
              buildInput("Enter Option 4", optionController4, "4"),
              buildOptionSelector(),
              ElevatedButton(
                onPressed: () async {
                  var isvalid = formGlobalKey.currentState!.validate();

                  if (isvalid && (correctAnswerIndex != 0)) {
                    var q = {
                      "question": questionController.text,
                      "options": [
                        optionController1.text,
                        optionController2.text,
                        optionController3.text,
                        optionController4.text
                      ],
                      "correctAnswerIndex": correctAnswerIndex
                    };
                    await firebase.addQuiz(q);
                    clearInput();
                    showToast("add question", Colors.green);
                  } else {
                    showToast("select the correct ", Colors.red);
                  }
                },
                child: const Text("Save Quize"),
              )
            ],
          ),
        ),
      ),
    );
  }

  clearInput() {
    setState(() {
      correctAnswerIndex = 0;
      questionController.text = "";
      optionController2.text = "";
      optionController1.text = "";
      optionController3.text = "";
      optionController4.text = "";
      isSelected = [false, false, false, false];
    });
  }

  buildOptionSelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              isSelected: isSelected,
              children: const [
                Text(
                  "1",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "2",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "3",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "4",
                  style: TextStyle(fontSize: 20),
                ),
              ],
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    if (index == i) {
                      isSelected[i] = true;
                    } else {
                      isSelected[i] = false;
                    }
                  }
                  correctAnswerIndex = index + 1;
                  print("${index + 1}");
                });
              },
            ),
          ],
        ),
        h10,
        const Text(
          "Select correct option from above numbers.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.purple),
        ),
        h10,
      ],
    );
  }

  buildInput(hinttext, tcontroller, letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.blue,
              border: Border.all(
                width: 1,
                style: BorderStyle.solid,
              ),
              // borderRadius: BorderRadius.circular(25),
              shape: BoxShape.circle,
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          w10,
          Expanded(
            child: TextFormField(
              controller: tcontroller,
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return "Enter a text";
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: hinttext,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
        ],
      ),
    );
  }

  showToast(msg, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
