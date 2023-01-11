import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/firebase_controller.dart';

class QuizListPage extends StatefulWidget {
  const QuizListPage({Key? key}) : super(key: key);

  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  var fireController = Get.find<FirebaseController>();
  var textController = TextEditingController();
  String searchWord = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireController.getQuiz();

    Future.delayed(const Duration(microseconds: 500));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Quizez '),
      ),
      body: GetBuilder<FirebaseController>(builder: (controller) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: TextField(
                      controller: textController,
                      onChanged: (s) {
                        controller.filter(textController.text);
                      },
                      decoration: InputDecoration(
                        hintText: "Enter a text",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: IconButton(
                            icon: const Icon(Icons.search, size: 25),
                            onPressed: () {
                              controller.filter(textController.text);
                            },
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.filteredList.length,
                    itemBuilder: (conx, index) {
                      var doc = controller.filteredList.elementAt(index);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade200,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            controller.delete(doc["question"]);
                            textController.clear();
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                        title: Text(
                          doc["question"],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ],
            ));
      }),
    );
  }
}
