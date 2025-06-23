import 'package:flutter/material.dart';


class StudentFormsPage extends StatefulWidget {
  @override
  _StudentFormsPageState createState() => _StudentFormsPageState();
}

class _StudentFormsPageState extends State<StudentFormsPage> {
  int _selectedIndex = 0;

  Future<List<Map<String, String>>> fetchForms() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      {'title': 'Admission Form', 'description': 'Form for student admissions.', 'deadline': '20 Jun, 5:00 PM'},
      {'title': 'Scholarship Form', 'description': 'Apply for scholarships here.', 'deadline': '22 Jun, 11:59 PM'},
      {'title': 'Hostel Request', 'description': 'Request for hostel accommodation.', 'deadline': '25 Jun, 3:00 PM'},
      {'title': 'Library Access', 'description': 'Library membership form.', 'deadline': '30 Jun, 1:00 PM'},
      {'title': 'Internship Approval', 'description': 'Request internship approval.', 'deadline': '28 Jun, 10:00 AM'},
      {'title': 'Medical Leave', 'description': 'Apply for medical leave.', 'deadline': '18 Jun, 4:30 PM'},
      {'title': 'Exam Retake', 'description': 'Retake form for missed exams.', 'deadline': '19 Jun, 9:00 AM'},
      {'title': 'Course Drop', 'description': 'Drop a course officially.', 'deadline': '21 Jun, 2:00 PM'},
      {'title': 'Feedback Form', 'description': 'Provide course feedback.', 'deadline': '27 Jun, 8:00 PM'},
      {'title': 'Transport Request', 'description': 'Bus/Transport services request.', 'deadline': '23 Jun, 6:00 PM'},
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildMainContent() {
    if (_selectedIndex == 0) {
      return Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Student',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: fetchForms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading forms.', style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No forms available.', style: TextStyle(color: Colors.white)));
                }

                final forms = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: forms.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              forms[index]['title'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text(forms[index]['description'] ?? ''),
                            SizedBox(height: 6),
                            Text(
                              'Deadline: ${forms[index]['deadline']}',
                              style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text("View Form"),
                              ),
                            ),
                          ],
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
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: Icon(Icons.article, color: Colors.white),
            title: Text('Filled', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.access_time, color: Colors.white),
            title: Text('Expired', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text('Details', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          'Profile Section',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Blue gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2193b0), // Light blue
                  Color(0xFF6dd5ed), // Mid blue
                  Color(0xFF1e3c72), // Deep blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(child: buildMainContent()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF2176FF),
              unselectedItemColor: Colors.black45,
              elevation: 0,
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