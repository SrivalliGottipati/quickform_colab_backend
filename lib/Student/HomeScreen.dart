// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// class StudentScreen extends StatefulWidget {
//   final String email;
//   StudentScreen({
//     required this.email,
//   });
//   @override
//   _StudentScreenState createState() => _StudentScreenState();
// }
// class _StudentScreenState extends State<StudentScreen> with TickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _titleController;
//   late AnimationController _searchBarController;
//   @override
//   void initState() {
//     super.initState();
//     _titleController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );
//     _searchBarController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _titleController.forward();
//     _searchBarController.forward();
//   }
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _searchBarController.dispose();
//     super.dispose();
//   }
//   Future<List<Map<String, String>>> fetchForms() async {
//     await Future.delayed(Duration(seconds: 2));
//     return [
//       {'title': 'Admission Form', 'description': 'Form for student admissions.', 'deadline': '20 Jun, 5:00 PM'},
//       {'title': 'Scholarship Form', 'description': 'Apply for scholarships here.', 'deadline': '22 Jun, 11:59 PM'},
//       {'title': 'Hostel Request', 'description': 'Request for hostel accommodation.', 'deadline': '25 Jun, 3:00 PM'},
//       {'title': 'Library Access', 'description': 'Library membership form.', 'deadline': '30 Jun, 1:00 PM'},
//       {'title': 'Internship Approval', 'description': 'Request internship approval.', 'deadline': '28 Jun, 10:00 AM'},
//       {'title': 'Medical Leave', 'description': 'Apply for medical leave.', 'deadline': '18 Jun, 4:30 PM'},
//       {'title': 'Exam Retake', 'description': 'Retake form for missed exams.', 'deadline': '19 Jun, 9:00 AM'},
//       {'title': 'Course Drop', 'description': 'Drop a course officially.', 'deadline': '21 Jun, 2:00 PM'},
//       {'title': 'Feedback Form', 'description': 'Provide course feedback.', 'deadline': '27 Jun, 8:00 PM'},
//       {'title': 'Transport Request', 'description': 'Bus/Transport services request.', 'deadline': '23 Jun, 6:00 PM'},
//     ];
//   }
//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }
//   Widget buildMainContent() {
//     if (_selectedIndex == 0) {
//       return Column(
//         key: ValueKey('formsPage'),
//         children: [
//           SizedBox(height: 50),
//           FadeTransition(
//             opacity: _titleController,
//             child: SlideTransition(
//               position: Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero)
//                   .animate(_titleController),
//               child: Text(
//                 'Hello, ${widget.email.split('@')[0]}!',
//                 style: GoogleFonts.montserrat(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Expanded(
//             child: FutureBuilder<List<Map<String, String>>>(
//               future: fetchForms(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                       child: CircularProgressIndicator(color: Colors.blueAccent));
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error loading forms.'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(child: Text('No forms available.'));
//                 }
//
//                 final forms = snapshot.data!;
//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: forms.length,
//                   itemBuilder: (context, index) {
//                     return TweenAnimationBuilder(
//                       duration: Duration(milliseconds: 400 + index * 100),
//                       tween: Tween<double>(begin: 0, end: 1),
//                       curve: Curves.easeOutCubic,
//                       builder: (context, value, child) {
//                         return Opacity(
//                           opacity: value,
//                           child: Transform.translate(
//                             offset: Offset(0, 50 * (1 - value)),
//                             child: child,
//                           ),
//                         );
//                       },
//                       child: Card(
//                         color: Colors.white.withOpacity(0.9),
//                         shadowColor: Colors.blueAccent.withOpacity(0.2),
//                         margin: EdgeInsets.only(bottom: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 8,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(forms[index]['title'] ?? '',
//                                   style: GoogleFonts.montserrat(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18)),
//                               SizedBox(height: 4),
//                               Text(forms[index]['description'] ?? '',
//                                   style: GoogleFonts.montserrat()),
//                               SizedBox(height: 6),
//                               Text('Deadline: ${forms[index]['deadline']}',
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.redAccent,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500,
//                                   )),
//                               SizedBox(height: 10),
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: AnimatedScale(
//                                   duration: Duration(milliseconds: 200),
//                                   scale: 1,
//                                   child: ElevatedButton(
//                                     onPressed: () {},
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Color.fromRGBO(142, 224, 243,1),
//                                       foregroundColor: Colors.white,
//                                       elevation: 4,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(24),
//                                       ),
//                                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                     ),
//                                     child: Text("View Form",
//                                         style: GoogleFonts.montserrat(color:Colors.black )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     } else if (_selectedIndex == 1) {
//       final tiles = [
//         {'icon': Icons.article, 'label': 'Filled'},
//         {'icon': Icons.access_time, 'label': 'Expired'},
//         {'icon': Icons.info_outline, 'label': 'Details'},
//         {'icon': Icons.settings, 'label': 'Settings'},
//       ];
//       return ListView.builder(
//         key: ValueKey('filledPage'),
//         padding: EdgeInsets.symmetric(vertical: 16),
//         itemCount: tiles.length,
//         itemBuilder: (context, index) {
//           return TweenAnimationBuilder(
//             duration: Duration(milliseconds: 300 + index * 100),
//             tween: Tween<double>(begin: 0, end: 1),
//             builder: (context, value, child) {
//               return Opacity(
//                 opacity: value,
//                 child: Transform.translate(
//                   offset: Offset(0, 30 * (1 - value)),
//                   child: child,
//                 ),
//               );
//             },
//             child: ListTile(
//               leading: Icon(tiles[index]['icon'] as IconData, color: Colors.black87),
//               title: Text(tiles[index]['label'] as String,
//                   style: GoogleFonts.montserrat(color: Colors.black87)),
//               onTap: () {},
//             ),
//           );
//         },
//       );
//     } else {
//       return Center(
//         key: ValueKey('profilePage'),
//         child: TweenAnimationBuilder(
//           duration: Duration(milliseconds: 500),
//           tween: Tween<double>(begin: 0, end: 1),
//           builder: (context, value, child) {
//             return Opacity(
//               opacity: value,
//               child: Transform.scale(scale: value, child: child),
//             );
//           },
//           child: Text(
//             'Profile Section',
//             style: GoogleFonts.montserrat(fontSize: 20, color: Colors.black87),
//           ),
//         ),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color.fromARGB(255, 86, 198, 242),
//             Color.fromARGB(255, 128, 198, 242),
//             Color.fromARGB(255, 139, 227, 244),
//             Color.fromARGB(255, 210, 227, 244),
//           ],
//           stops: [0.0, 0.2, 0.6, 0.7],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         extendBody: true,
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(0, -0.4),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//               parent: _searchBarController,
//               curve: Curves.easeOut,
//             )),
//             child: TextField(
//               style: GoogleFonts.montserrat(),
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 hintStyle: GoogleFonts.montserrat(),
//                 prefixIcon: Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white60,
//                 contentPadding: EdgeInsets.symmetric(vertical: 0),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 12.0),
//               child: Icon(Icons.notifications, color: Colors.black87),
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: AnimatedSwitcher(
//             duration: Duration(milliseconds: 500),
//             transitionBuilder: (child, animation) => FadeTransition(
//               opacity: animation,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: Offset(0.1, 0),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: child,
//               ),
//             ),
//             child: buildMainContent(),
//           ),
//         ),
//         bottomNavigationBar: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//           child: Container(
//             height: 95,
//             decoration: BoxDecoration(color: Colors.white),
//             child: BottomNavigationBar(
//               backgroundColor: Colors.transparent,
//               currentIndex: _selectedIndex,
//               selectedItemColor: Colors.black,
//               unselectedItemColor: Colors.lightBlueAccent,
//               elevation: 0,
//               selectedLabelStyle: GoogleFonts.montserrat(),
//               unselectedLabelStyle: GoogleFonts.montserrat(),
//               onTap: _onItemTapped,
//               items: const [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.description_outlined),
//                   label: 'Forms',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.check_circle_outline),
//                   label: 'Filled Forms',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person_outline),
//                   label: 'Profile',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late Map<String, dynamic> studentData;
  late Future<List<Map<String, String>>> _formsFuture;

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
      if (user == null) {
        throw Exception('No logged-in user');
      }
      final currentUserID = user.uid;

      final studentData = await fetchStudentInfoByUID(currentUserID);
      print("Student Data: $studentData");

      // Convert year to int (if stored as string)
      int studentYear;
      if (studentData['year'] is int) {
        studentYear = studentData['year'];
      } else if (studentData['year'] is String) {
        studentYear = int.tryParse(studentData['year'].trim()) ?? -1;
      } else {
        studentYear = -1;
      }

      // Trim student section
      String studentSection = (studentData['section'] ?? '').toString().trim();
      String studentBranchId = (studentData['branchId'] ?? '').toString().trim();
      String studentCollegeId = (studentData['collegeId'] ?? '').toString().trim();

      final formsSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .where('status', isEqualTo: 'active')
          .get();

      final List<Map<String, String>> matchedForms = [];

      for (var doc in formsSnapshot.docs) {
        final data = doc.data();

        final List<dynamic>? targetYears = data['targetYears'];
        final List<dynamic>? targetColleges = data['tragetColleges']; // Use exact field name from your DB

        if (targetYears == null || !targetYears.contains(studentYear)) continue;
        if (targetColleges == null || !targetColleges.map((e) => e.toString().trim()).contains(studentCollegeId)) continue;

        final List<dynamic>? targetBranches = data['targetBranches'];
        final List<dynamic>? targetSections = data['targetSections'];

        if (targetBranches != null && !targetBranches.map((e) => e.toString().trim()).contains(studentBranchId)) continue;
        if (targetSections != null && !targetSections.map((e) => e.toString().trim()).contains(studentSection)) continue;

        matchedForms.add({
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'deadline': data['expiresAt'] != null
              ? (data['expiresAt'] as Timestamp).toDate().toLocal().toString()
              : '',
          'link': data['link'] ?? '',
        });
      }

      return matchedForms;
    } catch (e, stacktrace) {
      print('Error in fetchForms: $e');
      print(stacktrace);
      rethrow; // so FutureBuilder receives the error
    }
  }




  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget buildMainContent() {
    if (_selectedIndex == 0) {
      return Column(
        key: ValueKey('formsPage'),
        children: [
          SizedBox(height: 50),
          FadeTransition(
            opacity: _titleController,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -0.2), end: Offset.zero).animate(_titleController),
              child: Text(
                'Hello, ${widget.email.split('@')[0]}!',
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
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
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: forms.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 400 + index * 100),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.easeOutCubic,
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
                        color: Colors.white.withOpacity(0.9),
                        shadowColor: Colors.blueAccent.withOpacity(0.2),
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(forms[index]['title'] ?? '',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              SizedBox(height: 4),
                              Text(forms[index]['description'] ?? '',
                                  style: GoogleFonts.montserrat()),
                              SizedBox(height: 6),
                              Text('Deadline: ${forms[index]['deadline']}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  )),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: AnimatedScale(
                                  duration: Duration(milliseconds: 200),
                                  scale: 1,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(142, 224, 243, 1),
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                    child: Text("View Form",
                                        style: GoogleFonts.montserrat(color: Colors.black)),
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
      );
    } else if (_selectedIndex == 1) {
      return Center(child: Text('Filled Forms Page'));
    } else {
      return Center(
        key: ValueKey('profilePage'),
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(scale: value, child: child),
            );
          },
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.4),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _searchBarController,
              curve: Curves.easeOut,
            )),
            child: TextField(
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.notifications, color: Colors.black87),
            ),
          ],
        ),
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: buildMainContent(),
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            height: 95,
            decoration: BoxDecoration(color: Colors.white),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.lightBlueAccent,
              elevation: 0,
              selectedLabelStyle: GoogleFonts.montserrat(),
              unselectedLabelStyle: GoogleFonts.montserrat(),
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  label: 'Forms',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Filled Forms',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

