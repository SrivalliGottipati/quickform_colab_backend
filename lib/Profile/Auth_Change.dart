import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickform/Admin/Homepage.dart';

import 'package:quickform/Student/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginScreen.dart';

class AuthChange extends StatelessWidget {
  const AuthChange({super.key});

  Future<String?> getUserRole(String uid) async {
    final roleDoc = await FirebaseFirestore.instance
        .collection('roles')
        .doc(uid)
        .get();

    return roleDoc.data()?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<String?>(
            future: getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final role = roleSnapshot.data;

              if (role == 'Admin') {
                return const HomePage();
              } else if (role == 'Student') {
                return StudentScreen(email: user.email ?? '');
              } else {
                return const LoginScreen(); // fallback
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
