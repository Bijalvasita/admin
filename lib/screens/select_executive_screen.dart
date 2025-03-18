import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectExecutiveScreen extends StatelessWidget {
  final Map<String, dynamic> caseDetails;
  final String documentId;

  const SelectExecutiveScreen({
    Key? key,
    required this.caseDetails,
    required this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> executives = [
      'John Doe',
      'Jane Smith',
      'Alice Johnson',
      'Robert Brown',
      'Emily Davis'
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Select an Executive')),
      body: ListView.builder(
        itemCount: executives.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(executives[index]),
              onTap: () {
                _assignToExecutive(context, executives[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _assignToExecutive(BuildContext context, String executiveName) async {
    try {
      await FirebaseFirestore.instance
          .collection('cases')
          .doc(documentId)
          .update({'assignedExecutive': executiveName});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $executiveName')),
      );

      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning executive: $e')),
      );
    }
  }
}
