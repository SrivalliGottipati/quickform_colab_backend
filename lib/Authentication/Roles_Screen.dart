import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Admin_SignUP.dart';
import 'User_SignUp.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  int? tappedIndex;
  bool animate = false;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonWidth = size.width * 0.8;
    final double buttonHeight = size.height * 0.07;
    final String role;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 0, 5, 60),
              Color.fromARGB(255, 0, 80, 226),
              Color.fromARGB(255, 89, 206, 241),
              Color.fromARGB(255, 209, 227, 246),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Top section
            SizedBox(
              height: size.height * 0.48,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "What is your role?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mulish(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.08,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We’ll personalize content for you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mulish(
                        fontSize: size.width * 0.040,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: size.height * 0.06),

            _buildRoleButton(
              label: "I'm a Student",
              index: 0,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () async {
                setState(() {
                  tappedIndex = 0;
                  animate = true;
                });

                await Future.delayed(const Duration(milliseconds: 250));

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  UserSignUpScreen(role: "Student")),
                  ).then((_) {
                    setState(() {
                      tappedIndex = null;
                      animate = false;
                    });
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            _buildRoleButton(
              label: "I'm an Admin",
              index: 1,
              width: buttonWidth,
              height: buttonHeight,
              onTap: () async {
                setState(() {
                  tappedIndex = 1;
                  animate = true;
                });

                await Future.delayed(const Duration(milliseconds: 250));

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AdminSignUpScreen(role: "Admin")),
                  ).then((_) {
                    setState(() {
                      tappedIndex = null;
                      animate = false;
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    required int index,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    final isTapped = tappedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isTapped && animate
              ? const Color.fromARGB(255, 3, 2, 2)
              : Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w600,
              fontSize: width * 0.05,
              color: isTapped && animate ? Colors.white : Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
