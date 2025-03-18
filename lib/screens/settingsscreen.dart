import 'package:flutter/material.dart';
import 'PaymentReminderScreen.dart';

class SettingsScreen extends StatelessWidget {
  final Color maroon = const Color(0xFF800000);

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('User Profile'),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email ID'),
            subtitle: Text('user@example.com'), // Replace with dynamic data
            trailing: Icon(Icons.edit),
            onTap: () {
              // Navigate to an email editing screen
            },
          ),
          Divider(),

          _buildSectionHeader('Notifications'),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Set Payment Due Reminder'),
            subtitle: Text('Remind for a specific loan number'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentReminderScreen(),
                ),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: maroon,
        ),
      ),
    );
  }
}
   