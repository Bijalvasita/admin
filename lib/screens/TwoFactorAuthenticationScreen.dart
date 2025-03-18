import 'package:flutter/material.dart';

class TwoFactorAuthenticationScreen extends StatefulWidget {
  @override
  _TwoFactorAuthenticationScreenState createState() =>
      _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState
    extends State<TwoFactorAuthenticationScreen> {
  bool _is2FAEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two-Factor Authentication'),
        backgroundColor: Color(0xFF800000), // Custom maroon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle for 2FA
            SwitchListTile(
              title: Text('Enable Two-Factor Authentication'),
              value: _is2FAEnabled,
              onChanged: (bool value) {
                setState(() {
                  _is2FAEnabled = value;
                });
              },
            ),
            SizedBox(height: 20),
            // Description
            Text(
              'Two-factor authentication provides an additional layer of security for your account by requiring a second form of verification.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Save Button
            ElevatedButton(
              onPressed: () {
                // Handle save changes for 2FA
                _showConfirmationDialog();
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700), // Gold color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(_is2FAEnabled
              ? 'Two-Factor Authentication has been enabled.'
              : 'Two-Factor Authentication has been disabled.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
