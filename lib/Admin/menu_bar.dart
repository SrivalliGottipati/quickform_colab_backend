import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../Authentication/LoginScreen.dart';
import 'Expired_Forms_Admin.dart';
import 'createformpage.dart';
import '../Admin/profile_page.dart';
import 'admin_provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final adminName = Provider.of<AdminProvider>(context).name;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDBF1FD), Color(0xFFB3E6FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome ${adminName.isNotEmpty ? adminName : 'Admin'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black26, height: 30),

            _buildDrawerItem(
              icon: Icons.description_outlined,
              label: 'Upload Forms',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateFormPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.check_circle,
              label: 'Expired Forms',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpiredFormsPage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      onTap: onTap,
    );
  }
}
