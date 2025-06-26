import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<ProfilePage> {
  final nameCtrl = TextEditingController();

  final List<String> groupOptions = ['Thub', 'Placement', 'College'];
  final List<String> collegeOptions = ['AU', 'ACET'];
  final List<String> branchOptions = ['CSE', 'AIML', 'ECE', 'IT', 'DS'];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AdminProvider>(context, listen: false);
    provider.fetchAdminDetails().then((_) {
      nameCtrl.text = provider.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildReadOnlyField("Email", provider.email),
            _buildReadOnlyField("Employee ID", provider.employeeId),
            _buildEditableField("Name", nameCtrl),
            _buildDropdown("Group", provider.group, groupOptions, (val) {
              setState(() {
                provider.group = val ?? '';
                if (provider.group != 'College') {
                  provider.college = '';
                  provider.branch = '';
                }
              });
            }),
            if (provider.group == 'College') ...[
              _buildDropdown("College", provider.college, collegeOptions, (val) {
                setState(() {
                  provider.college = val ?? '';
                });
              }),
              _buildDropdown("Branch", provider.branch, branchOptions, (val) {
                setState(() {
                  provider.branch = val ?? '';
                });
              }),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                provider.updateAdminProfile(
                  newName: nameCtrl.text.trim(),
                  newGroup: provider.group,
                  newCollege: provider.college,
                  newBranch: provider.branch,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Update Profile", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          enabled: false,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: options.contains(value) ? value : null,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
