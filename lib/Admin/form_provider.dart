import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormItem {
  final String id;
  final String title;
  final String description;
  final String link;
  final String status;
  final String deadline;
  final DateTime timestamp;

  final String subject;
  final String sender;
  final String profilePic;

  final Map<String, dynamic> createdBy;
  final List<String> targetColleges;
  final List<String> targetYears;
  final List<String> targetCourses;
  final List<String> targetBranches;
  final List<String> targetSections;
  final List<String> types;

  FormItem({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.status,
    required this.deadline,
    required this.timestamp,
    required this.subject,
    required this.sender,
    required this.profilePic,
    required this.createdBy,
    required this.targetColleges,
    required this.targetYears,
    required this.targetCourses,
    required this.targetBranches,
    required this.targetSections,
    required this.types,
  });

  factory FormItem.fromMap(String id, Map<String, dynamic> data) {
    return FormItem(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      link: data['link'] ?? '',
      status: data['status'] ?? 'unknown',
      deadline: data['expiresAt']?.toDate().toString() ?? '',
      timestamp: data['createdAt']?.toDate() ?? DateTime.now(),

      // Optional presentation fields
      subject: data['subject'] ?? 'Form Notification',
      sender: data['createdBy']?['adminID'] ?? 'Admin',
      profilePic: 'assets/profile.png',

      createdBy: Map<String, dynamic>.from(data['createdBy'] ?? {}),
      targetColleges: List<String>.from(data['targetcollege'] ?? []),
      targetYears: List<String>.from(data['targetyear'] ?? []),
      targetCourses: List<String>.from(data['targetcourse'] ?? []),
      targetBranches: List<String>.from(data['targetbranch'] ?? []),
      targetSections: List<String>.from(data['targetsection'] ?? []),
      types: List<String>.from(data['type'] ?? []),
    );
  }
}


class FormsProvider with ChangeNotifier {
  final List<FormItem> _items = [];
  List<FormItem> get items => _items;

  Future<void> fetchAdminForms() async {
    try {

      final adminUID = FirebaseAuth.instance.currentUser?.uid;

      if (adminUID == null) {
        print('No admin is logged in.');
        return;
      }

      final adminFormsSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(adminUID)
          .collection('AdminForms')
          .get();

      final formIds = adminFormsSnapshot.docs.map((doc) => doc.id).toList();

      final forms = <FormItem>[];

      for (String formId in formIds) {
        final formDoc = await FirebaseFirestore.instance
            .collection('forms')
            .doc(formId)
            .get();

        if (formDoc.exists) {
          final data = formDoc.data()!;
          forms.add(FormItem.fromMap(formDoc.id, data));
        }
      }

      _items.clear();
      _items.addAll(forms);
      notifyListeners();
    } catch (e) {
      print('Error loading admin forms: $e');
    }
  }
}
