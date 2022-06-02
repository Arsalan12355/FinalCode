import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surveillance_system/auth/login_new.dart';
import 'package:surveillance_system/screens/home.dart';
import 'package:surveillance_system/screens/verifyemail.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  late String imagePath;

  bool loading = false;

  // void pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final image = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     imagePath = image.path;
  //   });
  //   print(imagePath);
  // }


  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      setState(() {
        loading = true;
      });

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var signCre =
          await FirebaseAuth.instance.signInWithCredential(credential);

      String fullName = googleUser.displayName!;

      var names = fullName.split(' ');
      var firstName = names[0];
      var lastName = fullName.replaceAll(firstName, "");

      db
          .collection('users')
          .where('email', isEqualTo: signCre.user!.email)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          db.collection("users").doc(signCre.user!.uid).set({
            "firstName": firstName,
            "lastName": lastName,
            "email": googleUser.email,
            "image": googleUser.photoUrl,

          });
        }
      });


      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } catch (e) {
      setState(() {
        loading = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          });
      // print(e.message);

      // print(e.message.toString());
    }
  }






  signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });

    try {
      final String firstName = firstNameController.text;
      final String lastName = lastNameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      final String confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {}

      final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await db.collection("users").doc(user.user!.uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "image":
            "https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg",
        "isOAuth": "0",

      });

      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();

      print("Your registration has been completed !");

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => verifyotp()), (route) => false);
      Get.to(verifyotp());
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e.toString());
      Get.snackbar(
        "Something went wrong",
        e.toString(),
      );

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         content: Text(e.toString()),
      //       );
      //     });
    }
  }

  goBack() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: 160,
                  width: width,
                  color: Color(0xfff4d657),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Existing User?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 350,
                            height: 50,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)),
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
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  // color: Colors.pink,
                  margin: EdgeInsets.only(left: 10, top: 10),
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign up with",
                        style: TextStyle(
                          color: Color(0xfff4d657),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Surveillance-system",
                        style: TextStyle(
                          color: Color(0xfff4d657),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // todo; text field start from here
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: TextFormField(
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
                            labelStyle: TextStyle(color: Color(0xfff4d657)),
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
                            fillColor: Color.fromARGB(92, 158, 158, 158)),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: TextFormField(
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
                            labelStyle: TextStyle(color: Color(0xfff4d657)),
                            prefixIcon: Icon(
                              Icons.person,
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: TextFormField(
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
                              Icons.person,
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: TextFormField(
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
                            labelText: "Password",
                            labelStyle: TextStyle(color: Color(0xfff4d657)),
                            prefixIcon: Icon(
                              Icons.lock,
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 20, right: 20),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your confirm password";
                          } else if (value.length < 6) {
                            return "Your password is too short";
                          } else if (value != passwordController.text) {
                            return "Your password and confirmation password are not same";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Color(0xfff4d657)),
                            prefixIcon: Icon(
                              Icons.lock,
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
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: signUp,
                      child: Container(
                          width: 350,
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
              SizedBox(
                height: 15,
              ),
              Text(
                "Or signup with",
                style: TextStyle(color: Color(0xfff4d657), fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: loginWithGoogle,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/glogo.jpg"),
                ),
              )
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
    double w = size.width;
    double h = size.height;
    final path = Path();

    path.lineTo(0, h);
    // path.lineTo(w, h);
    path.quadraticBezierTo(w * 0.5, h - 100, w, h);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
