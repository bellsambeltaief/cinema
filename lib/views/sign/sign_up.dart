import 'package:cinemamovie/views/sign/sign_in.dart';
import 'package:cinemamovie/models/user.dart';
import 'package:cinemamovie/views/sign/widgets/account.dart';
import 'package:cinemamovie/views/sign/widgets/button_sign.dart';
import 'package:cinemamovie/views/sign/widgets/pic_detector.dart';
import 'package:cinemamovie/views/sign/widgets/text_field.dart';
import 'package:cinemamovie/widgets/app_top.dart';
import 'package:flutter/material.dart';
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
        Uri.parse("http://192.168.1.21:5000/api/users/check-email"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({'email': user.email}));

    setState(() {
      _emailExist = jsonDecode(res.body)["emailExist"];
    });
  }

  final _formKey = GlobalKey<FormState>();
  Future save(String url) async {
    var res = await post(
      Uri.parse("http://192.168.1.21:5000/api/users/signup"),
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
                  const AppTop(logoImage: 'images/logo.png', label: "SignUp",),
                    const SizedBox(
                      height: 25
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
                            :const  PicDetecotor(),
                      ),
                    ),
                  const TextFieldEnter(hintText: 'Enter Username'
                     
                   ),
                const  TextFieldEnter(hintText: " Enter Email"),
                 const  TextFieldEnter(hintText: " Enter Password"),
          
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55, 16, 16, 0),
                      child: ButtonSign(onPressed: (){
                          if (_formKey.currentState!.validate()) {
                                uploadFile();
                              } else {
                                debugPrint("not ok");
                              }
                      }, buttonText: 'SignUp',),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                      child: Account(onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignIn()));
          }, textAccount: 'SignIn', label:  'Already have Account ? ',),
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

