import 'package:flutter/material.dart';

class FilledFormsProvider with ChangeNotifier {
  final List<Map<String, String>> _filledForms = [];

  List<Map<String, String>> get filledForms => _filledForms;

  void addFilledForm(Map<String, String> form) {
    _filledForms.add(form);
    notifyListeners();
  }
}
