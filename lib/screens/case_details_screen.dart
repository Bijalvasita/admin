import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'uploadscreen.dart'; // Import your upload screen

class CaseDetailsScreen extends StatefulWidget {
  const CaseDetailsScreen({Key? key}) : super(key: key);

  @override
  _CaseDetailsScreenState createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  List<Map<String, dynamic>> _cases = [];
  String executiveEmail =
      'executive@example.com'; // Replace with the actual executive email ID

  @override
  void initState() {
    super.initState();
    _fetchCases();
  }

  Future<void> _fetchCases() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cases')
          .where('executiveEmail',
              isEqualTo: executiveEmail) // Filter by executive email
          .get();
      setState(() {
        _cases = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      _showDialog(
          'Error', 'Failed to fetch case details. Please try again later.');
      // Log the error for debugging purposes
      print('Error fetching cases: $e');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPDF(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        _showDialog('Error', 'Could not open PDF. Please try again later.');
      }
    } catch (e) {
      _showDialog('Error', 'Failed to open PDF. Please try again later.');
      // Log the error for debugging purposes
      print('Error opening PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cases.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _cases.length,
                itemBuilder: (context, index) {
                  final caseData = _cases[index];
                  final pdfUrl = caseData[
                      'pdfUrl']; // Assuming you store the PDF URL in Firestore

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Case Details',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ListTile(
                            title: const Text(
                              'Agreement ID',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(caseData['agreementId'] ?? 'N/A'),
                          ),
                          ListTile(
                            title: const Text(
                              'Customer Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(caseData['customerName'] ?? 'N/A'),
                          ),
                          ListTile(
                            title: const Text(
                              'Executive Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(caseData['executiveEmail'] ?? 'N/A'),
                          ),
                          if (pdfUrl != null)
                            ListTile(
                              title: const Text(
                                'Uploaded PDF',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.picture_as_pdf,
                                    color: Colors.red),
                                onPressed: () => _openPDF(pdfUrl),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
