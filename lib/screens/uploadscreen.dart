import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_drawer/models/case.dart';
import 'package:flutter_navigation_drawer/services/firestore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _selectedExecutive;
  List<Map<String, String>> _executives = [];
  String _fileName = '';
  Uint8List? _fileBytes;
  double _progress = 0.0;
  UploadTask? _uploadTask;

  @override
  void initState() {
    super.initState();
    _fetchExecutives();
  }

  Future<void> _fetchExecutives() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('executives').get();
      setState(() {
        _executives = snapshot.docs.map((doc) {
          return {
            'id': doc.id.toString(),
            'name': doc['name']?.toString() ?? 'Unknown'
          };
        }).toList();
      });
    } catch (e) {
      _showDialog('Error', 'Could not fetch executives. Please try again.');
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _fileBytes = result.files.single.bytes;
          _progress = 0.0;
        });
      } else {
        _showDialog('No File Selected', 'Please select a file.');
      }
    } catch (e) {
      _showDialog(
          'Error', 'An unexpected error occurred while selecting the file.');
    }
  }

  Future<void> _uploadFile() async {
    if (_fileBytes == null || _selectedExecutive == null) {
      _showDialog('Missing Data',
          'Please select an executive and a file before uploading.');
      return;
    }

    try {
      //TODO: uncomment this when you want to use firebase auth
      // User? user = FirebaseAuth.instance.currentUser;
      // if (user == null) {
      //   await FirebaseAuth.instance.signInAnonymously();
      // }

      log('Uploading file... start');
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('executive_uploads/$_selectedExecutive/$_fileName');
      _uploadTask = storageReference.putData(_fileBytes!);
      log('Uploading file... end');

      _uploadTask!.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      }, onError: (error) {
        _showDialog('Upload Error',
            'Failed to upload file. Please check your internet connection and try again.');
      });

      await _uploadTask;
      log('Upload complete!');
      log('File URL: ${storageReference.getDownloadURL()}');
      String downloadUrl = await storageReference.getDownloadURL();
      await FirebaseFirestore.instance.collection('executive_uploads').add({
        'executiveId': _selectedExecutive,
        'fileName': _fileName,
        'fileUrl': downloadUrl,
        'uploadedAt': Timestamp.now(),
      });

      log('File uploaded successfully! URL: $downloadUrl');
      _showDialog('Success', 'File uploaded successfully!');
      _uploadCasesToFirestore(_fileBytes!);
      setState(() {
        _uploadTask = null;
        _progress = 0.0;
      });
    } catch (e) {
      log(e.toString());
      _showDialog('Upload Error',
          'An error occurred while uploading. Please try again later.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload File to Executive')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedExecutive,
              hint: const Text('Select Executive'),
              items: _executives.map((exec) {
                return DropdownMenuItem<String>(
                  value: exec['id'],
                  child: Text(exec['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedExecutive = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadTask == null ? _selectFile : null,
              child: const Text('Select File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_fileBytes != null && _uploadTask == null)
                  ? _uploadFile
                  : null,
              child: const Text('Upload File'),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 20),
            Text(
              _fileName.isEmpty
                  ? 'No file selected'
                  : _progress < 1.0
                      ? 'Uploading: $_fileName (${(_progress * 100).toStringAsFixed(2)}%)'
                      : 'Upload Complete: $_fileName',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future _uploadCasesToFirestore(Uint8List uint8list) async {
    String csvString = utf8.decode(uint8list);

    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);

    List<Case> cases = csvData
        .skip(1)
        .map((row) => Case.fromCsv(row, _selectedExecutive!))
        .toList();
    await Firestore.instance.uploadCases(cases);
  }
}
