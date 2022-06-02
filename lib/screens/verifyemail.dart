import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surveillance_system/auth/login_new.dart';
import 'package:surveillance_system/screens/home.dart';
// import 'package:email_auth/email_auth.dart';


class verifyotp extends StatefulWidget {
  const verifyotp({ Key? key }) : super(key: key);

  @override
  _verifyotpState createState() => _verifyotpState();
}

class _verifyotpState extends State<verifyotp> {

  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user?.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer){
      checkEmailVerified();
    });



    super.initState();
  }


  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "An email has been sent to ${user!.email} please verify"
        ),
      ),
      // appBar: AppBar(
      //   title: Text("Verify Email"),
      // ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       TextField(
      //         controller: _emailController,
      //         decoration: InputDecoration(
      //           prefixIcon: Icon(Icons.mail),
      //           contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
      //           hintText: "Email",
      //           label: Text("Verify Email"),
      //           border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(15),
      //           ),
      //         ),      
      //       ),
      //       SizedBox(height: 20,),
      //       TextField(
      //         controller: _otpController,
      //         decoration: InputDecoration(
      //           prefixIcon: Icon(Icons.mail),
      //           contentPadding: EdgeInsets.fromLTRB(15, 17, 15, 17),
      //           hintText: "Verify OTP",
      //           label: Text("OTP"),
      //           border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(15),
      //           ),
      //         ),      
      //       ),
      //     ],
      //   ),
      // ),    
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user?.reload();
    if(user!.emailVerified){
      timer?.cancel();
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      Get.to(LoginPage());

    }
  }


}
