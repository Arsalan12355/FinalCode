// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:surveillance_system/screens/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class Update_Profile extends StatefulWidget {
  @override
  State<Update_Profile> createState() => _Update_ProfileState();
}

class _Update_ProfileState extends State<Update_Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? email;
  String? image;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool loading = false;

  currentUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        firstName = ds.data()!['firstName'];
        lastName = ds.data()!['lastName'];
        email = ds.data()!['email'];
        image = ds.data()!['image'];
        firstNameController.text = firstName!;
        lastNameController.text = lastName!;
        emailController.text = email!;
      }).catchError((e) {
        print(e);
      });
  }

  updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore db = FirebaseFirestore.instance;

      String updateFirstName = firstNameController.text;
      String updateLastName = lastNameController.text;
      db.collection('users').doc(firebaseUser!.uid).update({
        "firstName": updateFirstName,
        "lastName": updateLastName,
      });
      firstName = firstNameController.text;
      lastName = lastNameController.text;

      setState(() {
        firstName;
        lastName;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserProfile()),
          (route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

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
            title: Text(
              "Update profile",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: currentUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 230, 0),
                  ));

                return SingleChildScrollView(
                  
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(image!),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 20, right: 20),
                              child: TextFormField(
                                cursorColor: Colors.yellow,
                                controller: firstNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  } else if (value.length < 3) {
                                    return "Your name is too short";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelStyle:
                                        TextStyle(color: Color(0xfff4d657)),
                                    labelText: "First Name",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color(0xfff4d657),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(92, 158, 158, 158)),
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 15, left: 20, right: 20),
                            //   child: TextFormField(
                            //     controller: firstNameController,
                            //     keyboardType: TextInputType.name,
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'Please enter your name';
                            //       } else if (value.length < 3) {
                            //         return "Your name is too short";
                            //       }
                            //       return null;
                            //     },
                            //     decoration: InputDecoration(
                            //       labelText: "First Name",
                            //       prefixIcon: Icon(
                            //         Icons.email,
                            //         color: Colors.purple[500],
                            //       ),
                            //       filled: true,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 20, right: 20),
                              child: TextFormField(
                                cursorColor: Colors.yellow,
                                controller: lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  } else if (value.length < 3) {
                                    return "Your name is too short";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "Last Name",
                                    labelStyle:
                                        TextStyle(color: Color(0xfff4d657)),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color(0xfff4d657),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(92, 158, 158, 158)),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 15, left: 20, right: 20),
                            //   child: TextFormField(
                            //     controller: lastNameController,
                            //     keyboardType: TextInputType.name,
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return 'Please enter your last name';
                            //       } else if (value.length < 3) {
                            //         return "Your name is too short";
                            //       }
                            //       return null;
                            //     },
                            //     decoration: InputDecoration(
                            //       labelText: "Last Name",
                            //       prefixIcon: Icon(
                            //         Icons.email,
                            //         color: Colors.purple[500],
                            //       ),
                            //       filled: true,
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 20, right: 20),
                              child: TextFormField(
                                cursorColor: Colors.yellow,
                                controller: emailController,
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle:
                                        TextStyle(color: Color(0xfff4d657)),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xfff4d657),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(92, 158, 158, 158)),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: 15, left: 20, right: 20),
                            //   child: TextFormField(
                            //     readOnly: true,
                            //     enabled: false,
                            //     controller: emailController,
                            //     keyboardType: TextInputType.emailAddress,
                            //     decoration: InputDecoration(
                            //       labelText: "Email",
                            //       prefixIcon: Icon(
                            //         Icons.email,
                            //         color: Colors.purple[500],
                            //       ),
                            //       filled: true,
                            //     ),
                            //   ),
                            // ),
                            InkWell(
                              onTap: updateProfile,
                              child: Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Color(0xfff4d657),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Center(
                                  child: Text(
                                    "update",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            // ElevatedButton(
                            //     onPressed: updateProfile,
                            //     child: Text("Update")),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
