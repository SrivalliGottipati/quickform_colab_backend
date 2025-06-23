import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../AppColors.dart';
import 'createformpage.dart';
import 'form_provider.dart';
import 'menu_bar.dart';
class DetailPage extends StatelessWidget {
  final String subject;
  final String sender;
  final String profilePic;
  final String title;
  final String description;
  final String link;
  final String deadline;

  const DetailPage({
    super.key,
    required this.subject,
    required this.sender,
    required this.profilePic,
    required this.title,
    required this.description,
    required this.link,
    required this.deadline,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.tryParse(url)!;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                subject,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(profilePic),
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    sender,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _launchURL(link),
                child: Text(
                  'Link: $link',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Deadline: $deadline',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}





class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FormsProvider>(context, listen: false).fetchAdminForms();
    });
  }

  String getDateGroupLabel(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (date == today) {
      return 'Today';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }


  @override
  Widget build(BuildContext context) {
    final formsProvider = Provider.of<FormsProvider>(context);
    final filteredItems = formsProvider.items.where((item) {
      final query = searchQuery.toLowerCase();
      return item.title.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final groupedItems = <String, List<FormItem>>{};

    for (var item in filteredItems) {
      final group = getDateGroupLabel(item.timestamp);
      groupedItems.putIfAbsent(group, () => []).add(item);
    }



    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          title: const Text(
            'Quick Form',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,

        ),
        drawer: const MenuDrawer(),
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
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: groupedItems.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      ...entry.value.map((item) {
                        final formattedTime = DateFormat('hh:mm a').format(item.timestamp);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                border: Border.all(color: Colors.lightBlueAccent),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(item.profilePic),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),

                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm a').format(item.timestamp),
                                      style: const TextStyle(fontSize: 12, color: Colors.black38),
                                    ),
                                  ],
                                ),
                                subtitle: Text(item.subject),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailPage(
                                        subject: item.subject,
                                        sender: item.sender,
                                        profilePic: item.profilePic,
                                        title: item.title,
                                        description: item.description,
                                        link: item.link,
                                        deadline: item.deadline,
                                      ),
                                    ),
                                  );
                                },
                              )

                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            )

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
