import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProvider extends ChangeNotifier {
  String name = '';
  String email = '';
  String employeeId = '';
  String group = '';
  String college = '';
  String branch = '';

  bool isLoading = true;

  Future<void> fetchAdminDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      name = data['name'] ?? '';
      email = data['Email'] ?? '';
      employeeId = data['employee id'] ?? '';
      group = data['group'] ?? '';
      college = data['College'] ?? '';
      branch = data['Branch'] ?? '';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateAdminProfile({
    required String newName,
    required String newGroup,
    String? newCollege,
    String? newBranch,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('admins').doc(uid).update({
      'name': newName,
      'group': newGroup,
      'College': newGroup == 'College' ? newCollege ?? '' : '',
      'Branch': newGroup == 'College' ? newBranch ?? '' : '',
    });

    // Update local values
    name = newName;
    group = newGroup;
    college = newCollege ?? '';
    branch = newBranch ?? '';
    notifyListeners();
  }
}
