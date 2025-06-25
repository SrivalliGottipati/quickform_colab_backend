import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickform/Admin/profile_page.dart';
import '../Authentication/LoginScreen.dart';
import 'user_provider.dart'; // Adjust path if needed
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

          // Create Form
          _buildDrawerTile(
            icon: Icons.create,
            label: 'Create Form',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateFormPage()),
              );
            },
          ),

          // Profile
          _buildDrawerTile(
            icon: Icons.person,
            label: 'Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          // Logout
          _buildDrawerTile(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {
              user.logout();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              );

              Navigator.pop(context); // Closes the drawer first

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.lightBlue),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          onTap: onTap,
        ),
      ),
    );
  }
}
