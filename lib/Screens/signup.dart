import 'package:cinemamovie/Screens/signin.dart';
import 'package:cinemamovie/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _emailExist = false;
  Future checkEmailExist() async {
    var res = await post(
        Uri.parse("http://192.168.1.122:5000/api/users/check-email"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({'email': user.email}));

    setState(() {
      _emailExist = jsonDecode(res.body)["emailExist"];
    });
  }

  final _formKey = GlobalKey<FormState>();
  Future save(String url) async {
    var res = await post(
      Uri.parse("http://192.168.1.122:5000/api/users/signup"),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(
        {
          'email': user.email,
          'password': user.password,
          'userName': user.userName,
          'image': url
        },
      ),
    );

    debugPrint(jsonDecode(res.body)["message"]);

    if (jsonDecode(res.body)["message"] == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
      );
    }
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) {
      save("");
      return;
    }
    ;
    final fileName = path.basename(_photo!.path);

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
      await ref.putFile(_photo!);

      String url = (await ref.getDownloadURL()).toString();
      save(url);
    } catch (e) {
      debugPrint('error occured');
    }
  }

  User user = User('', '', '', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 90),
                    SizedBox(
                      height: 150,
                      width: 300,
                      child: Image.asset('images/logo.png'),
                    ),
                    Text(
                      "Signup",
                      style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: const Color.fromARGB(255, 255, 213, 0)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xffFDCF09),
                        child: _photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _photo!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: TextEditingController(text: user.userName),
                        onChanged: (value) {
                          user.userName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter something';
                          }
                        },
                        decoration: InputDecoration(
                            icon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 255, 213, 0),
                            ),
                            hintText: 'Enter Username',
                            hintStyle: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: TextEditingController(text: user.email),
                        onChanged: (value) {
                          user.email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter something';
                          } else if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return null;
                          } else {
                            return 'Enter valid email';
                          }
                        },
                        decoration: InputDecoration(
                            icon: const Icon(
                              Icons.email,
                              color: Color.fromARGB(255, 255, 213, 0),
                            ),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: TextEditingController(text: user.password),
                        onChanged: (value) {
                          user.password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter something';
                          }
                          if (value.length < 6) {
                            return 'Password must be longer than 6 characters !';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: const Icon(
                              Icons.vpn_key,
                              color: Color.fromARGB(255, 255, 213, 0),
                            ),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0))),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 255, 213, 0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55, 16, 16, 0),
                      child: SizedBox(
                        height: 50,
                        width: 400,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 246, 189, 0)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 255, 213, 0))))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                uploadFile();
                              } else {
                                debugPrint("not ok");
                              }
                            },
                            child: const Text(
                              "Signup",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                      child: Row(
                        children: [
                          const Text(
                            "Already have Account ? ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()));
                            },
                            child: const Text(
                              "Signin",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 213, 0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
