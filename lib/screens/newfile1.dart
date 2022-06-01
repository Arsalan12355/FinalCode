import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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





// Future<Album> fetchAlbum() async {
//   final response =
//       await http.get("https://jsonplaceholder.typicode.com/posts/1");
 
//   // Appropriate action depending upon the
//   // server response
//   if (response.statusCode == 200) {
//     return Album.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }
 
// class Album {
//   final int userId;
//   final int id;
//   final String title;
 
//   Album({required this.userId, required this.id, required this.title});
 
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//     );
//   }
// }




class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

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

  String? value1;

  //  final databaseRef = FirebaseDatabase.instance.ref("pi_data/url");
  // final Future<FirebaseApp> _future = Firebase.initializeApp();

// void printFirebase(){
//     databaseRef.once().then((DatabaseEvent event) {
//       Object? data = event.snapshot.value;
//       setState(() {
//         value1 = data as String?;
//       });

//       print('Data : $data');
//     });
//   }


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
          backgroundColor: const Color(0xfff4d657),
          title: const Text("Camera Live View"),
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
            initialUrl: "https://www.google.com"),
            );
  }
}
