import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surveillance_system/auth/forget_password.dart';
import 'package:surveillance_system/auth/sign_up.dart';
import 'package:surveillance_system/auth/sign_up_new.dart';
import 'package:surveillance_system/screens/home.dart';
import 'package:surveillance_system/screens/loading_screen.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  loginWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final String email = emailController.text;
      final String password = passwordController.text;
      final UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        Get.snackbar(
          "No user found for that email",
          "try different email or create new account.",
        );
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        Get.snackbar(
          "Wrong password provided for that user",
          "try to remember or forgot your password.",
        );
      } else {
        Get.snackbar(
          "Something went wrong",
          "please check you internet connection and try again.",
        );
      }

      print(e);
    }
  }

  goToSignUpScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  goToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  goToForgetPassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPassword()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return loading
        ? LoadingScreen()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        color: Color(0xfff4d657),
                        height: 600,
                        width: width,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, top: 30),
                                height: 120,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome to",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Surveillance-system",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Please Login to Continue",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isNotEmpty &&
                                            value.length > 7) {
                                          return null;
                                        } else if (value.length < 7 &&
                                            value.isNotEmpty) {
                                          return "Your email address is too short";
                                        } else {
                                          return "Please enter your email address";
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 20, right: 20),
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: passwordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your password";
                                        } else if (value.length < 6) {
                                          return "Your password is too short";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        labelText: "Password",
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: loginWithEmailPassword,
                                      child: Container(
                                          width: width * 0.9,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Center(
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Color(0xfff4d657),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: TextButton(
                                        onPressed: goToForgetPassword,
                                        child: Text("Forgot Password ?",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18))),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(color: Color(0xfff4d657), fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: goToSignUpScreen,
                      child: Container(
                          width: width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Color(0xfff4d657),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "SIGN UP",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
