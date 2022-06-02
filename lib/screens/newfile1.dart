import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:surveillance_system/screens/home.dart';
import 'package:webview_flutter/webview_flutter.dart';



// class User {
//   final int id;
//   final int userId;
//   final String title;
//   // final String body;
  
//   User({
//     required this.id,
//     required this.userId,
//     required this.title,
//     // required this.body,
//   });
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }


// Future<List<User>> getRequest() async {
// Future<http.Response> getSirenOn() async {
//     var url = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
//     final response = await http.get(url);
  
//     var responseData = json.decode(response.body);
//     print(responseData);

//     return response;
//   }

// Future<http.Response> getSirenof() async {
//     var url1 = Uri.parse("https://jsonplaceholder.typicode.com/posts/2");
//     final response = await http.get(url1);
  
//     var responseData = json.decode(response.body);
//     print(responseData);

//     return response;
//   }









class CameraScreen extends StatefulWidget {

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  final referencedata = FirebaseDatabase.instance;

Future<http.Response> getSirenOn() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");
    final response = await http.get(url);
  
    var responseData = json.decode(response.body);
    print(responseData);

    return response;
  }

Future<http.Response> getSirenof() async {
    var url1 = Uri.parse("https://jsonplaceholder.typicode.com/posts/2");
    final response = await http.get(url1);
  
    var responseData = json.decode(response.body);
    print(responseData);

    return response;
  }



  bool isActive = false;

  String? value1 = "true";




  @override
  void initState() {
    super.initState();
    
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
   }

    // var futureAlbum = fetchAlbum();
    // printFirebase();

    // _dbref = FirebaseDatabase.instance.ref("pi_data/url");
  }



  // Object? value;

  // DatabaseReference? _dbref;
  


  // void getUrl() {
  //   _dbref!.child('pi_data').child('url').onValue.listen((DatabaseEvent event) {
  //     Object? data = event.snapshot.value;
  //     setState(() {
  //       value1 = data;
  //     });
  //     //print('url: $data');
  //   });
  // }

  


  @override
  Widget build(BuildContext context) {
    final ref = referencedata.ref();
    // getUrl();
    
    // getRequest();
    if (isActive == true) {
      getSirenOn();
    }
    if (isActive == false) {
      getSirenof();
    }
    // print(value.toString());
    // printFirebase();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
                      leading: IconButton(
                onPressed: () {
                  ref
                  .child("pi_data")
                    .child("view")
                    .set("false")
                    .asStream();
                  Get.to(Home());
                },
                icon: Icon(Icons.arrow_back)),
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),

          backgroundColor: const Color(0xfff4d657),
          // title: const Text("Camera Live View"),
          centerTitle: true,
          title: Row(
            children: [
              Text(
              'Camera Live View'),
              Padding(padding: EdgeInsets.symmetric(horizontal: 18.0), ),
                  Text("Siren",textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                  ),
                  ),
            ],
          ) ,
           actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Switch(
                activeTrackColor: Colors.grey.shade700,
                inactiveTrackColor: Colors.grey.shade700,
                activeColor: Colors.amberAccent.shade400,
                inactiveThumbColor: Colors.amberAccent.shade400,
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                    // print(value);
                  });
                },
              ),
            ),
          ],
        ),
        body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            // initialUrl: "http://127.0.1.1:5000/"),
            initialUrl: "https://www.google.com/"),
            );
  }
}
