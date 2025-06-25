import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  final TextEditingController sectionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();

    if (!doc.exists) return;

    setState(() {
      studentData = doc.data();
      sectionController.text = studentData?['section'] ?? '';
      isLoading = false;
    });
  }

  Future<void> updateSection() async {
    final user = FirebaseAuth.instance.currentUser;
    final newSection = sectionController.text.trim();

    if (user == null || newSection.isEmpty) return;

    await FirebaseFirestore.instance.collection('students').doc(user.uid).update({
      'section': newSection,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Section updated successfully")),
    );
  }

  @override
  void dispose() {
    sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Student Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Avatar with initials
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        (studentData?['name'] ?? 'N/A').toString().isNotEmpty
                            ? studentData!['name'].toString().substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildProfileItem(Icons.person, 'Roll No', studentData?['Roll no'] ?? 'N/A'),
                    _buildProfileItem(Icons.account_circle, 'Name', studentData?['name'] ?? 'N/A'),
                    _buildProfileItem(Icons.email, 'Email', studentData?['email'] ?? 'N/A'),
                    _buildProfileItem(Icons.calendar_today, 'Year', studentData?['year'].toString() ?? 'N/A'),
                    _buildProfileItem(Icons.code, 'Branch', studentData?['branchId'] ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildSectionEditor(),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: updateSection,
                      icon: const Icon(Icons.update, color: Colors.white),
                      label: const Text(
                        "Update Section",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.lightBlue),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionEditor() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.class_, color: Colors.lightBlue),
        const SizedBox(width: 12),
        const Text(
          'Section:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: sectionController,
            decoration: InputDecoration(
              hintText: 'e.g., A, B, C...',
              filled: true,
              fillColor: const Color(0xFFF1F3F4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
