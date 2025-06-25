import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickform/Student/FormDetails_Student.dart';

class FilledFormsScreen extends StatefulWidget {
  const FilledFormsScreen({super.key});

  @override
  State<FilledFormsScreen> createState() => _FilledFormsScreenState();
}

class _FilledFormsScreenState extends State<FilledFormsScreen> {
  late Future<List<Map<String, dynamic>>> _filledFormsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filledFormsFuture = fetchFilledForms();
  }

  Future<List<Map<String, dynamic>>> fetchFilledForms() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final filledSnapshot = await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .collection('filledForms')
        .get();

    List<Map<String, dynamic>> filledForms = [];

    for (var doc in filledSnapshot.docs) {
      final formId = doc.id;
      final formSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc(formId)
          .get();

      if (formSnapshot.exists) {
        final data = formSnapshot.data()!;
        filledForms.add({
          'id': formId,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'deadline': data['expiresAt'] != null
              ? (data['expiresAt'] as Timestamp).toDate().toLocal().toString()
              : '',
          'link': data['link'] ?? '',
        });
      }
    }

    return filledForms;
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Filled Forms', style: GoogleFonts.montserrat(color: Colors.black)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
              Color(0xFF4FC3F7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _filledFormsFuture = fetchFilledForms(); // Reload data
                    });
                  },
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _filledFormsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());

                      if (!snapshot.hasData || snapshot.data!.isEmpty)
                        return Center(
                          child: Text('No filled forms found.', style: GoogleFonts.montserrat()),
                        );

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
                          final form = filteredForms[index];

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
                            child: Stack(
                              children: [
                                Card(
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
                                          children: [
                                            Icon(Icons.check_circle_outline, color: Colors.green, size: 26),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    form['title'] ?? '',
                                                    style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    form['description'] ?? '',
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 13.5,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => FormDetailsScreen(
                                                    form: form.map((key, value) =>
                                                        MapEntry(key, value.toString())),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'View Form',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13.5,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 12,
                                  top: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Filled',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
