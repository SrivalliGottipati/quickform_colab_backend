import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Admin/Homepage.dart';
import '../Student/HomeScreen.dart';
import 'Roles_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailctrl = TextEditingController();
  final passctrl = TextEditingController();


  Future<void> RolesSelection() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCred = await auth.signInWithEmailAndPassword(
        email: emailctrl.text.trim(),
        password: passctrl.text.trim(),
      );

      String uid = userCred.user!.uid;

      DocumentSnapshot roleDoc = await FirebaseFirestore.instance
          .collection('roles')
          .doc(uid)
          .get();

      if (roleDoc.exists) {
        String role = roleDoc['role'];

        if (role == 'Student') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentScreen(email: emailctrl.text.trim())),
          );
        } else if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()), // Your admin homepage
          );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("Unknown role. Please contact support.")),
          // );
          showPopupMessage(context, "Unknown role. Please contact support");
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Role not assigned. Contact support.")),
        // );
        showPopupMessage(context, "Role not assigned. Contact support");
      }
    } on SocketException {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Please connect to the internet")),
      // );
      showPopupMessage(context, "Please connect to the internet");
    } on FirebaseAuthException catch (e) {
      authErrors(e.code);
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Unexpected error: $e")),
      // );
      showPopupMessage(context, "Unexpected error: $e");
    }
  }

  void _resetpass() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailctrl.text.trim(),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Password reset link has been sent to your email")),
      // );
      showPopupMessage(context, "Password reset link has been sent to your email");
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Failed to send reset link: $error")),
      // );
      showPopupMessage(context, "Failed to send reset link: $error");
    }
  }

  void showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Notice"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 201, 239),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
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
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 15),
                      TextField(
                        controller: emailctrl,
                        decoration: InputDecoration(
                          labelText: "Email",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _resetpass,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>RolesScreen()));
                            },
                            child: const Text("SignUp", style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          if (passctrl.text.trim().isNotEmpty &&
                              emailctrl.text.trim().isNotEmpty &&
                              passctrl.text.trim().length >= 6) {
                            RolesSelection();
                          } else {
                            showPopupMessage(context, "Please fill the form");
                          }
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text("Sign In", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> createAccount() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   try {
  //     await auth.signInWithEmailAndPassword(
  //       email: emailctrl.text.trim(),
  //       password: passctrl.text.trim(),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => StudentScreen(
  //             email: emailctrl.text.trim()),
  //       ),
  //     );
  //   } on SocketException {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please connect to the internet")),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     authErrors(e.code);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Unexpected error: $e")),
  //     );
  //   }
  // }

  void authErrors(String code) {
    String message;
    switch (code) {
      case 'invalid-email':
        message = "The email address is badly formatted.";
        break;
      case 'user-disabled':
        message = "This account has been disabled.";
        break;
      case 'user-not-found':
        message = "No account found with this email.";
        break;
      case 'wrong-password':
        message = "Incorrect password. Please try again.";
        break;
      case 'too-many-requests':
        message = "Too many attempts. Try again later.";
        break;
      default:
        message = "Authentication failed. [$code]";
    }

    showPopupMessage(context, "$message");
  }
}
