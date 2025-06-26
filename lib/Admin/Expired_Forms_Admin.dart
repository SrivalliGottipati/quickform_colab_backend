import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Admin/FormDetails_Admin.dart';
import 'form_provider.dart';

class ExpiredFormsPage extends StatefulWidget {
  const ExpiredFormsPage({super.key});

  @override
  State<ExpiredFormsPage> createState() => _ExpiredFormsPageState();
}

class _ExpiredFormsPageState extends State<ExpiredFormsPage> {
  late Future<void> _expiredFormsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _expiredFormsFuture = _fetchExpiredForms();
  }

  Future<void> _fetchExpiredForms() async {
    await Provider.of<FormsProvider>(context, listen: false).fetchAdminForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 179, 229, 252),
              Color.fromARGB(255, 129, 212, 250),
              Color.fromARGB(255, 79, 195, 247),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header + Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Expired Forms",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: GoogleFonts.montserrat(),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search expired forms...',
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              // Main Content Area (List + Refresh)
              Expanded(
                child: FutureBuilder(
                  future: _expiredFormsFuture,
                  builder: (context, snapshot) {
                    final formsProvider = Provider.of<FormsProvider>(context);
                    final forms = formsProvider.items;

                    final now = DateTime.now();
                    final expiredForms = forms
                        .where((f) => DateTime.tryParse(f.deadline)?.isBefore(now) ?? false)
                        .toList();

                    final filteredForms = expiredForms.where((form) {
                      final query = _searchQuery.toLowerCase();
                      return form.title.toLowerCase().contains(query) ||
                          form.description.toLowerCase().contains(query);
                    }).toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _expiredFormsFuture = _fetchExpiredForms();
                        });
                        await _expiredFormsFuture;
                      },
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(color: Colors.blueAccent),
                        ),
                      )
                          : filteredForms.isEmpty
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text('No expired forms found.'),
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                          "Expired",
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
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.5,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FormDetailsScreen(form: form),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blueAccent,
                                        ),
                                        child: Text(
                                          "View Form",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
