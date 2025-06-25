import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ExpiredForms_Student.dart';
import 'FormDetails_Student.dart';

class StudentScreen extends StatefulWidget {
  final String email;
  StudentScreen({required this.email});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _titleController;
  late AnimationController _searchBarController;

  late String studentEmail;
  late Future<List<Map<String, String>>> _formsFuture;

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    studentEmail = widget.email;
    _titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _searchBarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _titleController.forward();
    _searchBarController.forward();
    _formsFuture = fetchForms();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _searchBarController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchStudentInfoByUID(String uid) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();

    if (!docSnapshot.exists) throw Exception('Student not found');
    return docSnapshot.data()!;
  }

  Future<List<Map<String, String>>> fetchForms() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No logged-in user');
      final currentUserID = user.uid;

      final studentData = await fetchStudentInfoByUID(currentUserID);

      // Extract student details
      String studentYear = studentData['year'].toString().trim();         // e.g., "4"
      String studentSection = studentData['section'].toString().trim();   // e.g., "C"
      String studentBranch = studentData['branch'].toString().trim();     // e.g., "AIML"
      String studentCollege = studentData['college'].toString().trim();   // e.g., "AU"
      String studentCourse = studentData['course'].toString().trim();     // e.g., "B Tech"

      final formsSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .where('status', isEqualTo: 'active')
          .get();

      final List<Map<String, String>> matchedForms = [];

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

        // Skip expired forms
        final expiresAt = data['expiresAt'];
        if (expiresAt != null &&
            (expiresAt as Timestamp).toDate().isBefore(DateTime.now())) {
          continue;
        }

        matchedForms.add({
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'deadline': expiresAt != null
              ? (expiresAt as Timestamp).toDate().toLocal().toString()
              : '',
          'link': data['link'] ?? '',
        });
      }

      return matchedForms;
    } catch (e, stacktrace) {
      print('Error in fetchForms: $e');
      print(stacktrace);
      rethrow;
    }
  }




  String _calculateTimeLeft(String? deadlineString) {
    if (deadlineString == null || deadlineString.isEmpty) return '';
    try {
      final deadline = DateTime.parse(deadlineString);
      final now = DateTime.now();
      final difference = deadline.difference(now);
      if (difference.isNegative) return "Expired";
      if (difference.inDays > 0) return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} left";
      if (difference.inHours > 0) return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} left";
      return "${difference.inMinutes} min left";
    } catch (_) {
      return '';
    }
  }

  void _onMenuSelect(int index) {
    Navigator.pop(context); // Close drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildMainContent() {
    if (_selectedIndex == 0) {
      return FutureBuilder<List<Map<String, String>>>(
        future: _formsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading forms.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No forms available.'));
          }

          final forms = snapshot.data!;
          final filteredForms = forms.where((form) {
            final title = form['title']?.toLowerCase() ?? '';
            return title.contains(_searchQuery);
          }).toList();

          if (filteredForms.isEmpty) {
            return Center(child: Text('No matching forms found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _formsFuture = fetchForms(); // Re-fetch forms
              });
              await _formsFuture;
            },
            child: ListView.builder(
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
                                _calculateTimeLeft(filteredForms[index]['deadline']),
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
            ),
          );
        },
      );
    } else if (_selectedIndex == 1) {
      return Center(child: Text('Filled Forms Page'));
    } else {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(scale: value, child: child),
          );
        },
        child: Center(
          child: Text(
            'Profile Section',
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 86, 198, 242),
            Color.fromARGB(255, 128, 198, 242),
            Color.fromARGB(255, 139, 227, 244),
            Color.fromARGB(255, 210, 227, 244),
          ],
          stops: [0.0, 0.2, 0.6, 0.7],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Text(
                  'Welcome ${widget.email.split('@')[0]}',
                  style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.description_outlined),
                title: Text('Forms'),
                onTap: () => _onMenuSelect(0),
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text('Filled Forms'),
                onTap: () => _onMenuSelect(1),
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text('Expired Forms'),
                onTap: () {
                  Navigator.pop(context); // close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExpiredFormsScreen()),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
                onTap: () => _onMenuSelect(3),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: FadeTransition(
            opacity: _titleController,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero).animate(_titleController),
              child: Text(
                'Hello, ${widget.email.split('@')[0]}!',
                style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.notifications, color: Colors.black87),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: _searchBarController, curve: Curves.easeOut)),
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
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: Offset(0.1, 0), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                  ),
                  child: buildMainContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
