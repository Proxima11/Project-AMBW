import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPengumumanScreen extends StatefulWidget {
  @override
  _AddPengumumanScreenState createState() => _AddPengumumanScreenState();
}

class _AddPengumumanScreenState extends State<AddPengumumanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _addPengumuman() async {
    if (_formKey.currentState!.validate()) {
      // Get the current date and format it
      final DateTime now = DateTime.now();
      final String formattedDate = _formatDate(now);

      final newItem = {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'tanggal': formattedDate, // Set the tanggal with the current date
      };

      final url = Uri.https(
        'ambw-leap-default-rtdb.firebaseio.com',
        'pengumuman.json',
      );

      final response = await http.post(
        url,
        body: json.encode(newItem),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        // Handle error here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add item.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pengumuman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a judul';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deskripsi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPengumuman,
                child: const Text('Add Pengumuman'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}