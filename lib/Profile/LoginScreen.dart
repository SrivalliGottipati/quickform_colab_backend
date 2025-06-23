import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickform/Profile/Roles_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailctrl =  TextEditingController();
  final passctrl = TextEditingController();

  void _resetpass () async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailctrl.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset link has been sent to your email")));
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send reset link: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 201, 239),
    body: SafeArea(
    child: SingleChildScrollView(
    reverse: true, // ensures bottom widgets stay visible when keyboard appears
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>RolesScreen()));
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
    createAccount();
    } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill the form")));
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
    ),);

  }

  Future<void> createAccount()async{
    FirebaseAuth auth = await FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
        email: emailctrl.text.trim(),
        password: passctrl.text.trim()
    ).then((value){
      print("Logged in with the account ${emailctrl.text.trim()} at ${passctrl.text.trim()}");
    }).onError((error,StackTrace){
      if(error is SocketException){
        print("Please connect to the internet");
      }
      else if(error is FirebaseAuthException){
        authErrors(error.code);
      }
      else{
        print("Issue with ${error}");
      }
    });
  }
  void authErrors(String code){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(code.replaceAll("-", " ").toString())));
  }
}