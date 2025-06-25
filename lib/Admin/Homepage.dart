import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quickform/Admin/FormDetails_Admin.dart';
import 'createformpage.dart';
import 'form_provider.dart';
import 'menu_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> _formsFuture;
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _formsFuture = _fetchForms();
  }

  Future<void> _fetchForms() async {
    await Provider.of<FormsProvider>(context, listen: false).fetchAdminForms();
  }

  String _calculateTimeLeft(String deadlineStr) {
    try {
      final deadline = DateTime.parse(deadlineStr);
      final difference = deadline.difference(DateTime.now());
      if (difference.isNegative) return "Expired";
      return "${difference.inHours}h left";
    } catch (e) {
      return "N/A";
    }
  }

  Widget buildMainContent() {
    if (_selectedIndex == 0) {
      return FutureBuilder(
        future: _formsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading forms.'));
          }

          final formsProvider = Provider.of<FormsProvider>(context);
          final forms = formsProvider.items;

          final filteredForms = forms.where((form) {
            return form.title.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredForms.isEmpty) {
            return const Center(child: Text('No matching forms found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _formsFuture = _fetchForms();
              });
              await _formsFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    margin: const EdgeInsets.only(bottom: 12),
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
                                  form.title,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _calculateTimeLeft(form.deadline),
                                style: GoogleFonts.montserrat(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            form.description,
                            style: GoogleFonts.montserrat(fontSize: 13.5, color: Colors.grey[800]),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormDetailsScreen(form: form),
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
      return const Center(child: Text('Filled Forms Page'));
    } else {
      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(opacity: value, child: Transform.scale(scale: value, child: child));
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
    return SafeArea(
      child: Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text(
            'Quick Form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(child: buildMainContent()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateFormPage()),
            );
          },
        ),
      ),
    );
  }
}

