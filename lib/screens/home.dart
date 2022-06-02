// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surveillance_system/Api/notification_api.dart';
import 'package:surveillance_system/auth/forget_password.dart';
import 'package:surveillance_system/auth/login_new.dart';
import 'package:surveillance_system/screens/camera_screen.dart';
import 'package:surveillance_system/screens/newfile1.dart';
import 'package:surveillance_system/screens/update_profile.dart';
import 'package:surveillance_system/screens/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/change_pasword.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  // logOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     googleSignIn.disconnect();
  //     setState(() {});
  //     print("user diconnected");

  //     // Navigator.of(context).pushAndRemoveUntil(
  //     //     MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  //     Get.to(LoginPage());
  //   // ignore: nullable_type_in_catch_clause
  //   }  catch (e) {
  //     print('Error ...:');
  //           print(e);
  //   };
  // }


    Future<void> logout(BuildContext context) async {
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

  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? isOAuth;


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
        isOAuth = ds.data()!['isOAuth'];
        print("isOAuth1: $isOAuth");

      }).catchError((e) {
        print(e);
                  print("isOAuth2: $isOAuth");
      });
  }

  goToProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  }

  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.ref();
    NotificationApi.init();
    listenNotifications();
    getValue();
    getDetect1();

  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Home()));

  DatabaseReference? _dbref;

  // void _notification(String? title, String? desc) async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@drawable/ic_flutter_notification');
  //   final IOSInitializationSettings initializationSettingsIOS =
  //       IOSInitializationSettings(
  //           requestAlertPermission: true,
  //           requestBadgePermission: true,
  //           requestSoundPermission: true);
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           iOS: initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //   );

  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       'id', 'Surveillance System',
  //       description: "Motion Detected By Camera! Please Check What's Going On",
  //       importance: Importance.max);

  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       title,
  //       desc,
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               channelDescription: channel.description)));
  // }

  Object? valview;
  Object? valdetect;
  bool isValue = false;
  bool isValue2 = true;

  void getValue() async {
    _dbref!
        .child('pi_data')
        .child('view')
        .onValue
        .listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      setState(() {
        valview = data;
      });
      print('valview: $data');
    });
  }

  void getDetect1() async {
    _dbref!
        .child('pi_data')
        .child('detection')
        .onValue
        .listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      setState(() {
        valdetect= data;
      });
      print('valdetect: $data');
    });
  }


  
  

  @override
  Widget build(BuildContext context) {
    // getValue();
    // getDetect1();
    if (valview == true) {
      setState(() {
        isValue = false;
        print("isValue: $isValue");
      });
    }
    if (valdetect == false){
      setState(() {
        isValue2 = true;
        print("isValue2: $isValue2");
      });
    }
    // print("isValue: $isValue");
    if (valview== false && isValue == false && valdetect == true) {
      NotificationApi.showNotification(
          title: 'Warning!',
          body: "Motion Detected By Camera! Please Check What's Going On",
          payload: 'survelliance-system');
      setState(() {
        isValue = true;
        // print("isValue: $isValue");
      });
      // print("isValue: $isValue");
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xfff4d657),
        title: Text("Surveillance-System"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         logOut();
        //       },
        //       icon: Icon(Icons.logout)),
        // GestureDetector(
        //     onTap: logOut,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 15, right: 10),
        //       child: Text(
        //         "LogOut",
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        //       ),
        //     )),
        // ],
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color.fromARGB(185, 0, 0, 0),
          ),
          child: Drawer(
            //todo;
            // backgroundColor: Colors.white,
            child:
                //  SafeArea(
                //   child: ListView(
                //     children: [
                //       UserAccountsDrawerHeader(
                //         accountName: Text("$firstName $lastName"),
                //         accountEmail: Text("$email"),
                //         currentAccountPicture: CircleAvatar(
                //             // backgroundImage: NetworkImage(""),
                //             ),
                //         decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //             colors: [
                //               Color.fromARGB(255, 248, 222, 106),
                //               Color.fromARGB(255, 255, 208, 0),
                //             ],
                //             begin: const FractionalOffset(0.0, 0.0),
                //             end: const FractionalOffset(1.0, 0.0),
                //             stops: [0.0, 1.0],
                //             tileMode: TileMode.clamp,
                //           ),
                //         ),
                //       ),
                //       ListTile(
                //         leading: Icon(Icons.home),
                //         title: Text("Home"),
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),

                SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: currentUserProfile(),
                          builder: (context, snapshot) {
                            // if (snapshot.connectionState !=
                            //     ConnectionState.done)
                            //   return Center(child: CircularProgressIndicator());
                            if (snapshot.hasError)
                              return Text("Something Went Wrong");
                            else
                              return ListView(shrinkWrap: true, children: [
                                DrawerHeader(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 248, 222, 106),
                                          Color.fromARGB(255, 255, 208, 0),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundImage:
                                              NetworkImage(image ?? ''),
                                        ),
                                        Text("$firstName $lastName"),
                                        Text("$email"),
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                          }),
                      ListTile(
                        trailing: Container(
                          width: 5,
                          height: 20,
                          color: Colors.yellow,
                        ),
                        leading: Icon(
                          Icons.home,
                          color: Colors.yellow,
                        ),
                        title: Text(
                          "Dashboard",
                          style: TextStyle(color: Colors.yellow),
                        ),
                        onTap: () {
                          Get.to(Home());
                        },
                        // onTap: () {
                        //   Get.to(Home() == Home() ? null : null);
                        // },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person_add_alt,
                          color: Colors.yellow,
                        ),
                        title: Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.yellow),
                        ),
                        onTap: () {
                          Get.to(UserProfile());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.password_rounded,
                          color: Colors.yellow,
                        ),
                        title: Text(
                          "Change Password",
                          style: TextStyle(color: Colors.yellow),
                        ),
                        onTap: () 
                            {
                              if (isOAuth == "0" ){
                                Get.to(ChangePassword());
                              }
                              else{
                                print("\n\n\nUser is from third party login !!!!!!!!!\n\n\n");
                              }          
                            },

                        // {
                        //   Get.to(ForgetPassword());
                        // },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout_outlined,
                          color: Colors.yellow,
                        ),
                        title: Text(
                          "Log out",
                          style: TextStyle(color: Colors.yellow),
                        ),
                        onTap: () {
                          _newLogout();
                        },
                      ),
                    ]),
              ),
            ),
          )),
      body: Container(
        child: Center(
          child: InkWell(
            onTap: () {
              Get.to(CameraScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 248, 222, 106),
                    Color.fromARGB(255, 255, 208, 0),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              height: 50,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Open Camera",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.camera_alt_outlined)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
