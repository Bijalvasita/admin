import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ExecutiveManagementScreen.dart';
import 'PaymentReminderScreen.dart';
import 'ReminderListScreen.dart';
import 'case_details_screen.dart';
import 'settingsscreen.dart';
import 'uploadscreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _totalExecutives = 0;
  List<Map<String, dynamic>> _executiveList = [];

  @override
  void initState() {
    super.initState();
    _fetchExecutiveData();
  }

  // ✅ Fetch Executives from Firestore
  Future<void> _fetchExecutiveData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('executives').get();

      setState(() {
        _totalExecutives = snapshot.docs.length;
        _executiveList = snapshot.docs
            .map((doc) => {
                  "id": doc.id,
                  "name": doc["name"] ?? "No Name",
                  "email": doc["email"] ?? "No Email",
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching executives: $e');
    }
  }

  // ✅ Delete Executive from Firestore
  Future<void> _deleteExecutive(String id) async {
    await FirebaseFirestore.instance.collection('executives').doc(id).delete();
    _fetchExecutiveData();
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const Center(
      child: Text(
        'Dashboard Content',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    CaseDetailsScreen(key: PageStorageKey('CaseDetailsScreen')),
    ExecutiveManagementScreen(key: PageStorageKey('Executive')),
    UploadScreen(key: PageStorageKey('UploadScreen')),
    SettingsScreen(key: PageStorageKey('SettingsScreen')),
  ];

  final List<String> _appBarTitles = [
    'Dashboard',
    'Case Details',
    'Executive Management',
    'Upload',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              print("Notifications tapped!");
            },
          ),
          IconButton(
            icon: Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderListScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Hello!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text('Case Details'),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.people_alt_rounded),
              title: Text('Executive Management'),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.upload),
              title: Text('Upload'),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? _buildDashboardContent()
          : _widgetOptions[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentReminderScreen()),
                );
              },
              backgroundColor: Colors.orange,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Executives List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _executiveList.isEmpty
                ? Center(child: Text("No executives found"))
                : ListView.builder(
                    itemCount: _executiveList.length,
                    itemBuilder: (context, index) {
                      var executive = _executiveList[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(executive['name'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(executive['email']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.grey),
                                onPressed: () {
                                  // Implement Edit Functionality
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteExecutive(executive['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
