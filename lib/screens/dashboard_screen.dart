import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
  int _activeUsers = 10;
  int _inactiveUsers = 5;
  int _totalExecutives = 15;

  @override
  void initState() {
    super.initState();
    _fetchUserStatus();
  }

  Future<void> _fetchUserStatus() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('users').get();

      int activeCount = 0;
      int inactiveCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['status'] == 'active') {
          activeCount++;
        } else if (data['status'] == 'inactive') {
          inactiveCount++;
        }
      }

      setState(() {
        _activeUsers = snapshot.docs.isEmpty ? 10 : activeCount;
        _inactiveUsers = snapshot.docs.isEmpty ? 5 : inactiveCount;
        _totalExecutives = snapshot.docs.isEmpty ? 15 : snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _activeUsers = 10;
        _inactiveUsers = 5;
        _totalExecutives = 15;
      });
    }
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
            'Dashboard Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildPieChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: _chartSections(),
          centerSpaceRadius: 50,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: _activeUsers.toDouble(),
        title: 'Active\n$_activeUsers',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: _inactiveUsers.toDouble(),
        title: 'Inactive\n$_inactiveUsers',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: _totalExecutives.toDouble(),
        title: 'Total\n$_totalExecutives',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}
