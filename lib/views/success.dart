import 'package:cinemamovie/views/cart/cart.dart';
import 'package:cinemamovie/widgets/account.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Success extends StatefulWidget {
  const Success({
    Key? key,
  }) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 200,
            horizontal: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Payment Successfully",
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: const Color.fromARGB(255, 255, 213, 0),
                ),
              ),
              const SizedBox(height: 100),
              Center(
                child: Account(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cart(),
                        ),
                      );
                    },
                    textAccount: "My Cart",
                    label: "Want to check your Cart? "),
              )
            ],
          ),
        ),
      ),
    );
  }
}
