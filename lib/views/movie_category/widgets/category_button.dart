import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final VoidCallback onPressed;

  const CategoryButton({required this.category, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
 
                              margin: const EdgeInsets.only(right: 10.0),
            
                              child: ElevatedButton(
                                onPressed: onPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ( Color.fromARGB(255, 255, 213, 0) ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              
                                child: Text(
                                 category,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
  }
}

