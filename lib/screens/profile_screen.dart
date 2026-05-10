import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 12),
            Text(
              user?.displayName ?? 'User Name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard("Completed", "12", Colors.green),
                  const SizedBox(width: 15),
                  _buildStatCard("Pending", "5", Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildTile(
              Icons.dark_mode_outlined,
              "Dark Mode",
              trailing: Switch(value: false, onChanged: (v) {}),
            ),

            _buildTile(Icons.notifications_none, "Reminders"),
            _buildTile(Icons.help_outline, "Help & Support"),

            const Divider(indent: 20, endIndent: 20, height: 40),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,

                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
