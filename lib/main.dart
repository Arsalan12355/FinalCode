// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surveillance_system/auth/login_new.dart';
import 'package:surveillance_system/screens/home.dart';
import 'package:surveillance_system/screens/loading_screen.dart';
import 'package:surveillance_system/screens/update_profile.dart';
import 'package:surveillance_system/screens/user_profile.dart';
import 'auth/forget_password.dart';
import 'auth/sign_up.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child:
                Text("Something went wrong!", textDirection: TextDirection.ltr),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.yellow,
            ),
            debugShowCheckedModeBanner: false,
            home:
                // LoginPage(),
                FirebaseAuth.instance.currentUser == null
                    ? LoginPage()
                    : Home(),
            routes: {
              "/home": (context) => Home(),
              "/sign-up": (context) => SignUp(),
              "/login": (context) => LoginPage(),
              "/forget-password": (context) => ForgetPassword(),
              "/user-profile": (context) => UserProfile(),
              "/update-profile": (context) => Update_Profile(),
              "/loading-screen": (context) => LoadingScreen(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
            child: Text("Loading...", textDirection: TextDirection.ltr));
      },
    );
  }
}
