import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Student/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailctrl = TextEditingController();
  final passctrl = TextEditingController();

  void _resetpass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailctrl.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link has been sent to your email")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send reset link: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 201, 239),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            height: 150,
            width: 200,
            child: ClipRRect(
              child: Lottie.network(
                'https://lottie.host/9ce16054-a0ce-47e1-b1d7-9203b9c537c4/tKHjIy4gUQ.json',
                height: 150,
                repeat: true,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 15),
                  TextField(
                    controller: emailctrl,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passctrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _resetpass,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "SignUp",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      if (passctrl.text.trim().isNotEmpty &&
                          emailctrl.text.trim().isNotEmpty &&
                          passctrl.text.trim().length >= 6) {
                        createAccount();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill the form")),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> createAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
        email: emailctrl.text.trim(),
        password: passctrl.text.trim(),
      );

      // Navigate to StudentScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentFormsPage()),
      );
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please connect to the internet")),
      );
    } on FirebaseAuthException catch (e) {
      authErrors(e.code);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    }
  }

  void authErrors(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(code.replaceAll("-", " "))),
    );
  }
}