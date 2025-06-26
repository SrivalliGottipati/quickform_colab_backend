import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginScreen.dart';

class UserSignUpScreen extends StatefulWidget {
  final String role;
  const UserSignUpScreen({super.key, required this.role});
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
  String? selectedCollege;
  final clgnames = ["AU", "ACET"];
  final List<String> thubOptions = ["Thub", "NonThub"];
  String? selectedThub;
  final thubController = TextEditingController();
  bool _isLoading = false;


  String? selectedCourse;
  final List<String> courses = ["B Tech", "MCA"];
  final List<String> btechBranches = ["CSE", "AIML", "IT", "DS", "ECE"];
  String? selectedBranch;

  bool isPasswordValid(String password) {
    final pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&~]).{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool isEmailValid(String email) {
    final pattern = r'^[\w-\.]+@(acet\.ac\.in|aec\.edu\.in)$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Text("  College:", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DropdownMenu(
                              hintText: "Select",
                              selectedTrailingIcon: Icon(Icons.arrow_drop_up),
                              controller: clgctrl,
                              onSelected: (vals) {
                                selectedCollege = vals;
                                setState(() {});
                              },
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                              dropdownMenuEntries: clgnames
                                  .map((f) => DropdownMenuEntry(value: f, label: f))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Text("  Year:", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DropdownMenu(
                              hintText: "Select",
                              selectedTrailingIcon: Icon(Icons.arrow_drop_up),
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
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                              dropdownMenuEntries: dropvalues
                                  .map((f) => DropdownMenuEntry(value: f, label: f))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    Row(
                      children: [
                        Text("  Course:", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DropdownMenu<String>(
                              hintText: "Select",
                              selectedTrailingIcon: Icon(Icons.arrow_drop_up),
                              onSelected: (val) {
                                setState(() {
                                  selectedCourse = val;
                                  if (val != "B Tech") {
                                    selectedBranch = null;
                                    branchctrl.clear();
                                  }
                                });
                              },
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                              dropdownMenuEntries: courses
                                  .map((c) =>
                                  DropdownMenuEntry(value: c, label: c))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Branch dropdown if course is B Tech
                    if (selectedCourse == "B Tech")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Text("  Branch:", style: TextStyle(fontSize: 17)),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: DropdownMenu<String>(
                                hintText: "Select Branch",
                                selectedTrailingIcon: Icon(Icons.arrow_drop_up),
                                onSelected: (val) {
                                  setState(() {
                                    selectedBranch = val;
                                    branchctrl.text = val ?? '';
                                  });
                                },
                                inputDecorationTheme: InputDecorationTheme(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                menuStyle: MenuStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                ),
                                dropdownMenuEntries: btechBranches
                                    .map((branch) => DropdownMenuEntry(
                                    value: branch, label: branch))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text("  Type:", style: TextStyle(fontSize: 17)),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: DropdownMenu<String>(
                              hintText: "Select",
                              selectedTrailingIcon: Icon(Icons.arrow_drop_up),
                              controller: thubController,
                              onSelected: (val) {
                                setState(() {
                                  selectedThub = val;
                                });
                              },
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              menuStyle: MenuStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                              ),
                              dropdownMenuEntries: thubOptions
                                  .map((option) => DropdownMenuEntry(value: option, label: option))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    TextField(
                      controller: secctrl,
                      decoration: InputDecoration(
                        hintText: 'Section',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
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
                      onPressed: () async {
                        if (emailctrl.text.trim().isEmpty ||
                            passctrl.text.trim().isEmpty ||
                            namectrl.text.trim().isEmpty ||
                            conpassctrl.text.trim().isEmpty) {
                          showPopupMessage(context, "Please fill all the fields");
                        } else if (!isPasswordValid(passctrl.text.trim())) {
                          showPopupMessage(context,
                              "Password must be at least 8 characters,\ninclude a capital letter, number, and special character");
                        } else if (passctrl.text.trim() != conpassctrl.text.trim()) {
                          showPopupMessage(context, "Passwords do not match");
                        } else if (!isEmailValid(emailctrl.text.trim())) {
                          showPopupMessage(context,
                              "Use college email (@acet.ac.in or @aec.edu.in)");
                        } else {
                          // SHOW LOADING DIALOG
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (context) => const Center(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );

                          await createAccount();

                          // HIDE LOADING DIALOG
                          Navigator.pop(context);

                          // SHOW SUCCESS POPUP
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              title: Text("Success"),
                              content: Text("Account created successfully!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // close dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
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

  // Future<void> createAccount() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   try {
  //     UserCredential userCredential = await auth.createUserWithEmailAndPassword(
  //       email: emailctrl.text.trim(),
  //       password: passctrl.text.trim(),
  //     );
  //
  //     String uid = userCredential.user!.uid;
  //
  //     await FirebaseFirestore.instance.collection('students').doc(uid).set({
  //       'uid': uid,
  //       'email': emailctrl.text.trim(),
  //       'name': namectrl.text.trim(),
  //       'Roll no': rollctrl.text.trim(),
  //       'branch': branchctrl.text.trim(),
  //       'college': clgctrl.text.trim(),
  //       'course': selectedCourse,
  //       'thubStatus': selectedThub,
  //       'section': secctrl.text.trim(),
  //       'year': dropctrl.text.trim(),
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     await FirebaseFirestore.instance.collection('roles').doc(uid).set({
  //       'role': widget.role,
  //     });
  //
  //     print('Account created with ${emailctrl.text}');
  //   } on FirebaseAuthException catch (e) {
  //     authErrors(e.code);
  //   } on SocketException {
  //     showPopupMessage(context, "Please connect to the network.");
  //   } catch (e) {
  //     print("Unexpected error: $e");
  //     showPopupMessage(context, "Unexpected error occurred. Please try again.");
  //   }
  // }
  Future<void> createAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailctrl.text.trim(),
        password: passctrl.text.trim(),
      );

      User? user = userCredential.user;


      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        // showPopupMessage(context, "Verification email sent. Please check your inbox.");
      }

      String uid = user!.uid;

      await FirebaseFirestore.instance.collection('students').doc(uid).set({
        'uid': uid,
        'email': emailctrl.text.trim(),
        'name': namectrl.text.trim(),
        'Roll no': rollctrl.text.trim(),
        'branch': branchctrl.text.trim(),
        'college': clgctrl.text.trim(),
        'course': selectedCourse,
        'thubStatus': selectedThub,
        'section': secctrl.text.trim(),
        'year': dropctrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('roles').doc(uid).set({
        'role': widget.role,
      });

      print('Account created with ${emailctrl.text}');
    } on FirebaseAuthException catch (e) {
      authErrors(e.code);
    } on SocketException {
      showPopupMessage(context, "Please connect to the network.");
    } catch (e) {
      print("Unexpected error: $e");
      showPopupMessage(context, "Unexpected error occurred. Please try again.");
    }
  }



  void authErrors(String code) {
    if (code == "email-already-in-use") {
      showPopupMessage(context, "Email already exists.");
    } else if (code == "invalid-email") {
      showPopupMessage(context, "Invalid email address.");
    } else if (code == "weak-password") {
      showPopupMessage(context, "Weak password.");
    }
  }

}
