// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, sized_box_for_whitespace, use_key_in_widget_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:surveillance_system/auth/login_new.dart';
import 'package:surveillance_system/screens/home.dart';
import 'package:surveillance_system/screens/update_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  dynamic firstName;
  dynamic lastName;
  String? email;
  String? image;

  Stream profilesStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

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
      }).catchError((e) {
        print(e);
      });
  }

  goToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void closeDialog() {
    Navigator.of(context).pop();
  }

  void viewImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: closeDialog,
            child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image!),
                  ),
                )),
          );
        });
  }

  // logOut() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   final googleSignIn = GoogleSignIn();

  //   await auth.signOut();
  //   googleSignIn.disconnect();
  //   setState(() {});
  //   print("user diconnected");

  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  // }

  Future<void> logout(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    googleSignIn.disconnect();
    setState(() {});
    print("user diconnected");
    Get.to(LoginPage());
    
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> _newLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: Text(
            "logout",
            style: TextStyle(color: Colors.yellow),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Are you sure you want to logout from your account?",
                  style: TextStyle(color: Colors.yellow),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Approve',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                logout(context);
              },
            ),
          ],
        );
      },
    );
  }
  // void logOutDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               // ignore: prefer_const_literals_to_create_immutables
  //               children: [
  //                 Icon(
  //                   Icons.logout,
  //                   color: Colors.purple,
  //                 ),
  //                 Text(
  //                   "  Log Out",
  //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Text("Are you sure you want to logout from your account?"),
  //             SizedBox(
  //               height: 30,
  //             ),
  //             Row(
  //               children: [
  //                 TextButton(
  //                     onPressed: closeDialog,
  //                     child: Text(
  //                       "Cancel",
  //                       style: TextStyle(
  //                         color: Colors.grey,
  //                       ),
  //                     )),
  //                 SizedBox(
  //                   width: 50,
  //                 ),
  //                 TextButton(
  //                   onPressed: logOut,
  //                   style: TextButton.styleFrom(
  //                       backgroundColor: Colors.purple,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8))),
  //                   child: Text(
  //                     "LogOut",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ));
  //       });
  // }

  final TextEditingController editFirstName_controller =
      TextEditingController();

  final TextEditingController editLastName_controller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    editFirstName_controller.text = firstName;
  }

  editUserFirstName() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final String updatedUserName = editFirstName_controller.text;

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({"firstName": updatedUserName});
      firstName = editFirstName_controller.text;

      setState(() {
        firstName;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  editFirstName() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: editFirstName_controller,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      } else if (value.length < 3) {
                        return "Your name is too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "First name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.purple[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: editUserFirstName, child: Text("Edit name"))
              ],
            ),
          );
        });
  }

  editUserlastName() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final String updatedUserLastName = editLastName_controller.text;

      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({"lastName": updatedUserLastName});
      lastName = editLastName_controller.text;

      setState(() {
        lastName;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  editLastName() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: editLastName_controller,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      } else if (value.length < 3) {
                        return "Your name is too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Last name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.purple[500],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: editLastName, child: Text("Edit last name"))
              ],
            ),
          );
        });
  }

  goToUpdateProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Update_Profile()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Account Details",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Color(0xfff4d657),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: goToHome,
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    onPressed: _newLogout),
              ],
            ),
            body: FutureBuilder(
                future: currentUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.purple,
                    ));

                  return SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Column(children: [
                          Center(
                            child: Container(
                              child: GestureDetector(
                                onTap: viewImage,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(image ?? ''),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
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
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Center(
                              child: Text(
                                "First Name: $firstName".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
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
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Center(
                              child: Text(
                                "Last Name: $lastName".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
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
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Center(
                              child: Text(
                                "Email:  " + email!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: goToUpdateProfile,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
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
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Center(
                                child: Text(
                                  "update Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),

                          // ElevatedButton(
                          //     onPressed: goToUpdateProfile,
                          //     child: Text("Update profile"))
                        ])),
                  );
                })));
  }
}
