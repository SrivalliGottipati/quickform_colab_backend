import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickform/Admin/profile_page.dart';
import 'user_provider.dart'; // Adjust the path if needed

import 'createformpage.dart';


class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.lightBlue, size: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name.isNotEmpty ? user.name : 'Guest',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // Create Form Styled Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.blue.shade100,
                //     blurRadius: 4,
                //     offset: const Offset(2, 2),
                //   ),
                // ],
              ),
              child: ListTile(
                leading: const Icon(Icons.create, color: Colors.lightBlue),
                title: const Text('Create Form',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateFormPage()),
                  );
                },
              ),
            ),
          ),

          // Profile Styled Tile
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.blue.shade100,
                //     blurRadius: 4,
                //     offset: const Offset(2, 2),
                //   ),
                // ],
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.lightBlue),
                title: const Text('Profile',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}








