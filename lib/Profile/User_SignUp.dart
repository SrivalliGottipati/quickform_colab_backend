import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginScreen.dart';

class UserSignUpScreen extends StatefulWidget {

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final namectrl = TextEditingController();
  final rollctrl = TextEditingController();
  final emailctrl = TextEditingController();
  final passctrl = TextEditingController();
  final conpassctrl = TextEditingController();
  final clgctrl = TextEditingController();
  final branchctrl = TextEditingController();
  final secctrl = TextEditingController();
  final dropctrl = TextEditingController();
  String? selectedItem;
  final dropvalues = ["1", "2", "3", "4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3D9FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFFB3D9FF),
            padding: EdgeInsets.only(top: 80, bottom: 10),
            child: Lottie.network(
              'https://lottie.host/9ce16054-a0ce-47e1-b1d7-9203b9c537c4/tKHjIy4gUQ.json',
              height: 180,
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: namectrl,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: rollctrl,
                      decoration: InputDecoration(
                        hintText: 'Roll No',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: clgctrl,
                      decoration: InputDecoration(
                        hintText: 'College ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Text("  Year:",style: TextStyle(fontSize: 17),),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width:1,color: Colors.grey)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DropdownMenu(
                                hintText: "Select",
                                selectedTrailingIcon: Icon(
                                  Icons.arrow_drop_up,
                                ),
                                controller: dropctrl,
                                onSelected: (vals) {
                                  selectedItem = vals;
                                  setState(() {});
                                },
                                inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                menuStyle: MenuStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                dropdownMenuEntries: dropvalues.map((f) => DropdownMenuEntry(value: f, label: f)).toList()),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(height: 15,),

                    TextField(
                      controller: branchctrl,
                      decoration: InputDecoration(
                        hintText: 'Branch',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: secctrl,
                      decoration: InputDecoration(
                        hintText: 'Section',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: emailctrl,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: passctrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: conpassctrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if(passctrl.text.trim().isNotEmpty && emailctrl.text.trim().isNotEmpty && passctrl.text.trim().length>=6 && namectrl.text.trim().isNotEmpty && passctrl.text.trim()==conpassctrl.text.trim()){
                          createAccount();
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill the form")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createAccount() async{
    FirebaseAuth auth = await FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
        email: emailctrl.text.trim(),
        password: passctrl.text.trim()
    ).then((value)async{
      String uid = value.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': emailctrl.text.trim(),
        'name': namectrl.text.trim(),
        'Roll no': rollctrl.text.trim(),
        'branchId': branchctrl.text.trim(),
        'collegeId': clgctrl.text.trim(),
        'section': secctrl.text.trim(),
        'year': dropctrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Account created with ${emailctrl.text}');
    }).onError((error, StackTrace){
      if(error is SocketException){
        print('Please connect to the network');
      }
      else if(error is FirebaseAuthException){
        authErrors(error.code);
      }
      else{
        print('Issue with ${error}');
      }
    });
  }

  void authErrors(String code){
    if(code == "The email address is already in use by another account"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email already exists")));
    }
    else{
      String mess = code.replaceAll("-", " ").toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
    }
  }

}