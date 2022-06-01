// import 'dart:io';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   bool isActive = false;

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView(); 
//     }
//     _dbref = FirebaseDatabase.instance.ref();
//         getUrl();

//   }

//   String? value1;
//   Object? sirenOnUrl;
//   Object? sirenOffUrl;

//   DatabaseReference? _dbref;

//   void getUrl() async {
//      await _dbref!.child('pi_data').child('url').onValue.listen((DatabaseEvent event) {
//       Object? data = event.snapshot.value;
//       setState(() {
//         value1 = data as String?;
//       });
//       print('url: $value1');
//     });
//   }

//   // void getSirenOnurl() async {
//   //   _dbref!
//   //       .child('pi_data')
//   //       .child('siren_on_url')
//   //       .onValue
//   //       .listen((DatabaseEvent event) {
//   //     Object? data = event.snapshot.value;
//   //     setState(() {
//   //       sirenOnUrl = data;
//   //     });
//   //     //print('url: $data');
//   //   });
//   // }

//   // void getSirenOffurl() async {
//   //   _dbref!
//   //       .child('pi_data')
//   //       .child('siren_off_url')
//   //       .onValue
//   //       .listen((DatabaseEvent event) {
//   //     Object? data = event.snapshot.value;
//   //     setState(() {
//   //       sirenOffUrl = data;
//   //     });
//   //     //print('url: $data');
//   //   });
//   // }

//   // Future<http.Response> makeSirenOn() async {
//   //   var url = Uri.parse(sirenOnUrl.toString());
//   //   final response = await http.get(url);
//   //   return response;
//   //   //print(response);
//   // }

//   // Future<http.Response> makeSirenOff() async {
//   //   var url = Uri.parse(sirenOffUrl.toString());
//   //   final response = await http.get(url);
//   //   return response;
//   //   //print(response);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // getUrl();
//     // getSirenOffurl();
//     // getSirenOnurl();
//     // if (isActive == true) {
//     //   makeSirenOn();
//     // }
//     // if (isActive == false) {
//     //   makeSirenOff();
//     // }
//     // print(value.toString());
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: const Color(0xfff4d657),
//           title: const Text("Camera Live View"),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: Switch(
//                 activeTrackColor: Colors.grey.shade700,
//                 inactiveTrackColor: Colors.grey.shade700,
//                 activeColor: Colors.amberAccent.shade400,
//                 inactiveThumbColor: Colors.amberAccent.shade400,
//                 value: isActive,
//                 onChanged: (value) {
//                   setState(() {
//                     isActive = value;
//                     // print(value);
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: WebView(
//             javascriptMode: JavascriptMode.unrestricted,
//             initialUrl: "https://www.google.com"));
//   }
// }
