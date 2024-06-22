import 'dart:io';

import 'package:aplikasi_magang/mahasiswa/homepage_mhs.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class detail_lamaran extends StatefulWidget {
  @override
  State<detail_lamaran> createState() => _detail_lamaranState();
}

class _detail_lamaranState extends State<detail_lamaran> {
  // FirebaseStorage storage = FirebaseStorage.instance;
  // FirebaseDatabase database = FirebaseDatabase.instance;
  bool isLoading = false;
  late DropzoneViewController controller;

  Future<void> uploadPDF(File file) async {
    setState(() {
      isLoading = true;
    });

    String fileName = file.path.split('/').last;

    // try {
    //   // Upload file to Firebase Storage
    //   Reference ref = storage.ref().child('pdfs/$fileName');
    //   UploadTask uploadTask = ref.putFile(file);
    //   TaskSnapshot taskSnapshot = await uploadTask;

    //   // Get download URL
    //   String downloadURL = await taskSnapshot.ref.getDownloadURL();

    //   // Save download URL to Realtime Database
    //   DatabaseReference dbRef = database.reference().child('pdfs');
    //   dbRef.push().set({
    //     'url': downloadURL,
    //     'name': fileName,
    //   });

    //   setState(() {
    //     isLoading = false;
    //   });

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('File uploaded successfully')),
    //   );
    // } catch (e) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to upload file: $e')),
    //   );
    // }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      await uploadPDF(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Lamaran'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Job Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Job desk',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Requirement',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Ajukan Lamaran'),
                      content: Container(
                        child: Wrap(children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text("Nama"),
                                      Text("NRP"),
                                      Text("Email"),
                                      Text("Program Studi"),
                                      Text("IPK"),
                                      Text("No. Telp"),
                                    ],
                                  ),
                                  Text("Foto"),
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: pickFile,
                                      child: Text('Upload PDF'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Ajukan Lamaran'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
