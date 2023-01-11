import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/controllers/firebase_controller.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/views/pages/add_quiz_page.dart';
import 'package:quiz_app/views/widgets/leaderboard.dart';

import '../../constants.dart';
import 'quiz_page.dart';
import 'tool_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldSate = GlobalKey<ScaffoldState>();

  GetStorage storage = GetStorage();
  var quizController = Get.find<QuizController>();
  var firebaseController = Get.find<FirebaseController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseController.getLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldSate,
        appBar: buildAppBar(),
        drawer: buildDrawer(),
        body: buildBody());
  }

  buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: appColor.shade600,
      title: const Text("Flutter quiz app"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
              onPressed: () {
                firebaseController.getLeaderBoard();
                buildBottomSheet();
              },
              icon: const Icon(
                Icons.leaderboard,
                size: 30,
              )),
        )
      ],
    );
  }

  buildDrawer() {
    var userpic = widget.user.photoURL ?? "";
    return Drawer(
      backgroundColor: appColor.shade100.withOpacity(0.2),
      child: ListView(children: [
        h20,
        CircleAvatar(
          radius: 40,
          child: userpic.isNotEmpty
              ? Image.network(
                  widget.user.photoURL!,
                  width: 100,
                  height: 100,
                )
              : const FlutterLogo(),
        ),
        h20,
        Text(
          'Welcome! ${widget.user.displayName ?? " User"}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        h20,
        buildMenuTile(
          "Home",
          Icons.home,
          () {
            scaffoldSate.currentState!.closeDrawer();
          },
        ),
        buildMenuTile(
          "Share",
          Icons.share,
          () {
            scaffoldSate.currentState!.closeDrawer();
          },
        ),
        buildMenuTile(
          "Rate Us",
          Icons.rate_review,
          () {
            scaffoldSate.currentState!.closeDrawer();
          },
        ),
        buildMenuTile(
          "More Apps",
          Icons.more,
          () {
            scaffoldSate.currentState!.closeDrawer();
          },
        ),
        // buildMenuTile(
        //   "Tool Page",
        //   Icons.toll_outlined,
        //   () {
        //     scaffoldSate.currentState!.closeDrawer();
        //     Get.to(() => const ToolPage());
        //   },
        // ),
        widget.user.email == "admin@gmail.com"
            ? buildMenuTile(
                "Admin Page",
                Icons.toll_outlined,
                () {
                  scaffoldSate.currentState!.closeDrawer();
                  Get.to(() => const AddQuizPage());
                },
              )
            : SizedBox(),
        const Padding(
          padding: EdgeInsets.all(18.0),
          child: SignOutButton(),
        )
      ]),
    );
  }

  buildMenuTile(text, icon, onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              icon,
              color: Colors.lightBlue.shade100,
            ),
            title: Text(
              text,
              style: TextStyle(
                  color: Colors.lightBlue.shade100,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  buildBody() {
    return Column(
      children: [
        Image.asset(
          "assets/images/banner.jpg",
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                isFirstTime()
                    ? "The Online Quiz App"
                    : "Previous Scrore is ${storage.read('${widget.user.email}previousScore')}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Test your knowledge and sharpen your skills",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 17.5,
            ),
          ),
        ),
        h20,
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              appColor[600]!.withAlpha(200),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Text(
              "PLAY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          onPressed: () async {
            await quizController.setUser(widget.user);
            Get.to(() => const QuizPage());
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
      ],
    );
  }

  void buildBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (c) {
          return GetBuilder<FirebaseController>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: Text(
                      "Quiz Leaderboard",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),
                  ),
                ),
                const Divider(),
                Leaderboard(scrores: controller.learderScores),
              ],
            );
          });
        });
  }

  isFirstTime() {
    String previousScore =
        storage.read("${widget.user.email}totalScore") ?? "0";
    return previousScore == "0";
  }
}
