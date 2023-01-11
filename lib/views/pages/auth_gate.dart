import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/views/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is not signed in
          if (!snapshot.hasData) {
            // ...
            return SignInScreen(
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId:
                        "775672927669-sj53907asnt341p5ehgpot2so6k3g0a8.apps.googleusercontent.com")
              ],
              headerBuilder: ((context, constraints, shrinkOffset) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FlutterLogo(
                        size: 80,
                      ),
                      h10,
                      Text(
                        "Flutter Quiz App",
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.blue),
                      )
                    ],
                  )),
            );
          }

          // Render your application if authenticated
          return HomePage(
            user: snapshot.data!,
          );
        },
      ),
    );
  }
}
