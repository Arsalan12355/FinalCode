// ignore_for_file: prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:surveillance_system/auth/login.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:surveillance_system/auth/login_new.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      print("Password reset email sent");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Password reset email sent",
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Color(0xfff4d657),
          title: Center(
              child: Text(
            "Forget Password",
            style: TextStyle(color: Colors.black),
          )),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                //   child: TextFormField(
                //     controller: emailController,
                //     keyboardType: TextInputType.emailAddress,
                //     validator: (value) {
                //       if (value!.isNotEmpty && value.length > 7) {
                //         return null;
                //       } else if (value.length < 7 && value.isNotEmpty) {
                //         return "Your email address is too short";
                //       } else {
                //         return "Please enter your email address";
                //       }
                //     },
                //     decoration: InputDecoration(
                //       labelText: "Email",
                //       prefixIcon: Icon(
                //         Icons.email,
                //         color: Colors.purple[500],
                //       ),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(30.0),
                //         borderSide: BorderSide.none,
                //       ),
                //       filled: true,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                  child: TextFormField(
                    cursorColor: Colors.yellow,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length > 7) {
                        return null;
                      } else if (value.length < 7 && value.isNotEmpty) {
                        return "Your email address is too short";
                      } else {
                        return "Please enter your email address";
                      }
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Color(0xfff4d657)),
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xfff4d657),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(92, 158, 158, 158)),
                  ),
                ),
                InkWell(
                  onTap: resetPassword,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xfff4d657),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    height: 50,
                    width: 200,
                    child: Center(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: resetPassword, child: Text("Reset password"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
