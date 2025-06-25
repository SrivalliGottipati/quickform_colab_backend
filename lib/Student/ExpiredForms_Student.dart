import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FormDetails_Student.dart';

class ExpiredFormsScreen extends StatefulWidget {
  const ExpiredFormsScreen({Key? key}) : super(key: key);

  @override
  _ExpiredFormsScreenState createState() => _ExpiredFormsScreenState();
}

class _ExpiredFormsScreenState extends State<ExpiredFormsScreen> {
  late Future<List<Map<String, String>>> _expiredFormsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _expiredFormsFuture = fetchExpiredForms();
  }

  Future<Map<String, dynamic>> fetchStudentInfoByUID(String uid) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();

    if (!docSnapshot.exists) throw Exception('Student not found');
    return docSnapshot.data()!;
  }

  Future<List<Map<String, String>>> fetchExpiredForms() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No logged-in user');
      final currentUserID = user.uid;


      final studentData = await fetchStudentInfoByUID(currentUserID);

      // Extract student details
      String studentYear = studentData['year'].toString().trim();
      String studentSection = studentData['section'].toString().trim();
      String studentBranch = studentData['branch'].toString().trim();
      String studentCollege = studentData['college'].toString().trim();
      String studentCourse = studentData['course'].toString().trim();

      final formsSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .where('status', isEqualTo: 'active') // Only consider 'active' forms
          .get();

      final List<Map<String, String>> expiredForms = [];
      final now = DateTime.now();

      for (var doc in formsSnapshot.docs) {
        final data = doc.data();

        final List<dynamic>? targetYears = data['targetyear'];
        final List<dynamic>? targetColleges = data['targetcollege'];
        final List<dynamic>? targetBranches = data['targetbranch'];
        final List<dynamic>? targetSections = data['targetsection'];
        final List<dynamic>? targetCourses = data['targetcourse'];

        // Match only if list is non-empty
        if (targetYears != null && targetYears.isNotEmpty &&
            !targetYears.contains(studentYear)) continue;

        if (targetColleges != null && targetColleges.isNotEmpty &&
            !targetColleges.map((e) => e.toString().trim()).contains(studentCollege)) continue;

        if (targetBranches != null && targetBranches.isNotEmpty &&
            !targetBranches.map((e) => e.toString().trim()).contains(studentBranch)) continue;

        if (targetSections != null && targetSections.isNotEmpty &&
            !targetSections.map((e) => e.toString().trim()).contains(studentSection)) continue;

        if (targetCourses != null && targetCourses.isNotEmpty &&
            !targetCourses.map((e) => e.toString().trim()).contains(studentCourse)) continue;

        final expiresAt = data['expiresAt'];
        if (expiresAt != null && (expiresAt as Timestamp).toDate().isBefore(now)) {
          expiredForms.add({
            'title': data['title'] ?? '',
            'description': data['description'] ?? '',
            'deadline': (expiresAt).toDate().toLocal().toString(),
            'link': data['link'] ?? '',
          });
        }
      }

      return expiredForms;
    } catch (e, stacktrace) {
      print('Error in fetchExpiredForms: $e');
      print(stacktrace);
      rethrow;
    }
  }


  String _formatDeadline(String? deadlineString) {
    if (deadlineString == null || deadlineString.isEmpty) return '';
    try {
      final deadline = DateTime.parse(deadlineString);
      return "${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour}:${deadline.minute}";
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Expired Forms', style: GoogleFonts.montserrat(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          // Background gradient (same as home page)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB2FEFA),
                  Color(0xFF0ED2F7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Foreground UI
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                    style: GoogleFonts.montserrat(),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: GoogleFonts.montserrat(),
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white60,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: _expiredFormsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading expired forms.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No expired forms.'));
                      }

                      final forms = snapshot.data!;
                      final filteredForms = forms.where((form) {
                        final title = form['title']?.toLowerCase() ?? '';
                        return title.contains(_searchQuery);
                      }).toList();

                      if (filteredForms.isEmpty) {
                        return Center(child: Text('No matching forms found.'));
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredForms.length,
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder(
                            duration: Duration(milliseconds: 400 + index * 100),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 50 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white.withOpacity(0.95),
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            filteredForms[index]['title'] ?? '',
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Expired',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.redAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      filteredForms[index]['description'] ?? '',
                                      style: GoogleFonts.montserrat(fontSize: 13.5, color: Colors.grey[800]),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FormDetailsScreen(form: filteredForms[index]),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blueAccent,
                                        ),
                                        child: Text(
                                          "View Form",
                                          style: GoogleFonts.montserrat(fontSize: 13.5, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
