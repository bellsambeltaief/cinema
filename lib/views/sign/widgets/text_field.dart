import 'package:cinemamovie/models/user.dart';
import 'package:flutter/material.dart';

class TextFieldEnter extends StatelessWidget {
  final String hintText;
  const TextFieldEnter({
    super.key, required this.hintText,
 
  });



  @override
  Widget build(BuildContext context) {
    
  User user = User('', '', '', '');
    return Padding(
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
            hintText: hintText,
            hintStyle: const TextStyle(
                fontSize: 20.0, color: Colors.white),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 213, 0),),),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 213, 0),),),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 213, 0),),),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 255, 213, 0),),),),
      ),
    );
  }
}
