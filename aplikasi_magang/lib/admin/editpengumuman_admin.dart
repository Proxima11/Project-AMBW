import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPengumumanScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditPengumumanScreen({Key? key, required this.item}) : super(key: key);

  @override
  _EditPengumumanScreenState createState() => _EditPengumumanScreenState();
}

class _EditPengumumanScreenState extends State<EditPengumumanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.item['judul']);
    _deskripsiController = TextEditingController(text: widget.item['deskripsi']);
    _tanggalController = TextEditingController(text: widget.item['tanggal']);
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Get the current date and format it
      final DateTime now = DateTime.now();
      final String formattedDate = _formatDate(now);

      final updatedItem = {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'tanggal': formattedDate, // Update the tanggal with the current date
      };

      final url = Uri.https(
        'ambw-leap-default-rtdb.firebaseio.com',
        'pengumuman/${widget.item['id']}.json',
      );

      final response = await http.put(
        url,
        body: json.encode(updatedItem),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
      } else {
        // Handle error here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update item.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengumuman'),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: null, // Allows for multiple lines
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
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}