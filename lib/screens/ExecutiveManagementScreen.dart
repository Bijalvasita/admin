import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExecutiveManagementScreen extends StatefulWidget {
  const ExecutiveManagementScreen({Key? key}) : super(key: key);

  @override
  _ExecutiveManagementScreenState createState() =>
      _ExecutiveManagementScreenState();
}

class _ExecutiveManagementScreenState extends State<ExecutiveManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _editingExecutiveId;

  Future<void> _addExecutive() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('executives')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'uid': userCredential.user!.uid,
      });

      _showDialog("Success", "Executive added successfully!");
      _clearFields();
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  Future<void> _updateExecutive() async {
    if (_editingExecutiveId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('executives')
          .doc(_editingExecutiveId)
          .update({
        'name': _nameController.text,
        'email': _emailController.text,
      });

      if (mounted) {
        Navigator.pop(context); // Close the popup after saving
        _showDialog("Success", "Executive updated successfully!");
      }

      _editingExecutiveId = null;
      _clearFields();
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  Future<void> _deleteExecutive(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('executives').doc(uid).delete();
      _showDialog("Success", "Executive deleted successfully!");
    } catch (e) {
      _showDialog("Error", e.toString());
    }
  }

  void _editExecutive(String id, String name, String email) {
    setState(() {
      _editingExecutiveId = id;
      _nameController.text = name;
      _emailController.text = email;
    });
    _showEditDialog();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Executive"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _updateExecutive,
            child: const Text("Save"),
          ),
        ],
      ),
    );
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

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Executive Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name")),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email")),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _addExecutive, child: const Text("Add Executive")),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('executives')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['name']),
                        subtitle: Text(doc['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editExecutive(doc.id, doc['name'], doc['email']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteExecutive(doc.id),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
