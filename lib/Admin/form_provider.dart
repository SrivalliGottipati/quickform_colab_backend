// import 'package:flutter/material.dart';
//
// class FormItem {
//   final String title;
//   final String subject;
//   final String description;
//   final String link;
//   final String deadline;
//   final String profilePic;
//   final String sender;
//   final DateTime timestamp;
//
//   FormItem({
//     required this.title,
//     required this.subject,
//     required this.description,
//     required this.link,
//     required this.deadline,
//     required this.profilePic,
//     required this.sender,
//     required this.timestamp
//   });
// }
//
// class FormsProvider with ChangeNotifier {
//   final List<FormItem> _items = [
//   ];
//
//   List<FormItem> get items => List.unmodifiable(_items);
//
//   void addForm(FormItem form) {
//     _items.add(form);
//     notifyListeners();
//   }
// }
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormItem {
  final String id;
  final String title;
  final String subject;
  final String sender;
  final String profilePic;
  final String description;
  final String link;
  final String deadline;
  final DateTime timestamp;

  FormItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.sender,
    required this.profilePic,
    required this.description,
    required this.link,
    required this.deadline,
    required this.timestamp,
  });

  factory FormItem.fromMap(String id, Map<String, dynamic> data) {
    return FormItem(
      id: id,
      title: data['title'] ?? '',
      subject: data['subject'] ?? 'Form Notification',
      sender: data['createdBy']?['adminID'] ?? 'Admin',
      profilePic: 'assets/profile.png', // Replace with actual path or logic
      description: data['description'] ?? '',
      link: data['link'] ?? '',
      deadline: data['expiresAt']?.toDate().toString() ?? '',
      timestamp: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}

class FormsProvider with ChangeNotifier {
  final List<FormItem> _items = [];
  List<FormItem> get items => _items;

  Future<void> fetchAdminForms() async {
    try {
      final adminFormsSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc('admin123')
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
