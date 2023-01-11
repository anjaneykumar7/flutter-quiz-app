import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

class FirebaseController extends GetxController {
  List<dynamic> Quizez = [];
  List<dynamic> quizez20 = [];
  List<dynamic> learderScores = [];
  var filteredList = [];
  var quiz_limit = 3;

  Future<void> filter(search) async {
    filteredList =
        Quizez.where((item) => item["question"].contains(search)).toList();

    update();
  }

  Future<void> addQuiz(question) async {
    try {
      FirebaseFirestore.instance.collection('quizaptitude').add(question);
      if (kDebugMode) {
        print("Question added successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (kDebugMode) {
        print('error occured');
      }
    }
    update();
  }

  Future<void> getLeaderBoard() async {
    try {
      var ref = FirebaseFirestore.instance
          .collection('leaderboard')
          .orderBy("score", descending: true);

      QuerySnapshot querySnapshot = await ref.get();

      var alldata = querySnapshot.docs.map((doc) => doc.data()).toList;
      if (kDebugMode) {
        learderScores = querySnapshot.docs;
        // print(scores.elementAt(0)["name"]);
        // print(alldata);
        print("leaderboard fecth successfully");
      }
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> AddScore(score, email) async {
    try {
      FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(email)
          .set(score);
      if (kDebugMode) {
        print("score added successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (kDebugMode) {
        print('error occured');
      }
    }
    update();
  }

  Future<void> getQuiz() async {
    try {
      var ref = FirebaseFirestore.instance
          .collection('quizaptitude')
          .orderBy("question");
      QuerySnapshot querySnapshot = await ref.get();

      var alldata = querySnapshot.docs.map((doc) => doc.data()).toList;
      if (kDebugMode) {
        // print("${querySnapshot.docs}");
        Quizez = querySnapshot.docs;
        filteredList = querySnapshot.docs;
        print("Questions fecth successfully");
      }
    } catch (e) {
      print('error occured');
    }
    update();
  }

  Future<void> getQuiz20() async {
    try {
      var ref = FirebaseFirestore.instance.collection('quizaptitude');
      QuerySnapshot querySnapshot = await ref.get();

      if (kDebugMode) {
        // print("${querySnapshot.docs}");
        Quizez = querySnapshot.docs;
        Quizez.shuffle();
        quizez20 = Quizez.sublist(0, quiz_limit);
        print("Questions fecth successfully");
      }
    } catch (e) {
      print('error occured');
    }
    update();
  }

  Future<void> delete(element) async {
    var collection = FirebaseFirestore.instance.collection('quizaptitude');
    var snapshot = await collection.where('question', isEqualTo: element).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    getQuiz();
    update();
  }
}
