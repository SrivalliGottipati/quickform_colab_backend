import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'preethi';
  String _email = 'thub@gmail.com';
  String _id = 'ap2233e0';
  String _role = 'admin';
  String? profileImagePath;

  // Getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get role => _role;


  void logout() {
    clearUser();
  }


  // Method to set user data (called at signup/login)
  void setUser({
    required String name,
    required String email,
    required String id,
    required String role,
  }) {
    _name = name;
    _email = email;
    _id = id;
    _role = role;
    notifyListeners();
  }
  void setProfileImage(String path) {
    profileImagePath = path;
    notifyListeners();
  }


  void clearUser() {
    _name = '';
    _email = '';
    _id = '';
    _role = '';
    profileImagePath = null;
    notifyListeners();
  }
}
