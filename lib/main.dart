import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/views/pages/auth_gate.dart';

import 'controllers/firebase_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(seconds: 1));

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FirebaseController>(() => FirebaseController(), fenix: true);
    Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primaryColor: appColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: appColor)
            .copyWith(secondary: appColor),
      ),
      home: const AuthGate(),
    );
  }
}
