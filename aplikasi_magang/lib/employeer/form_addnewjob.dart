import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormAddNewJob extends StatefulWidget {
  final String data;
  const FormAddNewJob({required this.data, super.key});
  @override
  _FormAddNewJob createState() => _FormAddNewJob();
}

class _FormAddNewJob extends State<FormAddNewJob> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();
  final TextEditingController _waktucontroller = TextEditingController();

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _kuotaController.dispose();
    _waktucontroller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Ambil data dari text fields
      String company = _companyController.text;
      String jobTitle = _jobTitleController.text;
      String description = _descriptionController.text;
      String requirements = _requirementsController.text;
      int kuota = int.tryParse(_kuotaController.text) ?? 0; // Convert to int
      int waktu = int.tryParse(_waktucontroller.text) ?? 0; // Convert to int

      // URL Firebase Database
      final url = Uri.https(
        'ambw-leap-default-rtdb.firebaseio.com',
        'dataTawaran.json',
      );

      // Ambil data dari Firebase untuk menghitung panjang dataTawaran
      final getDataResponse = await http.get(url);
      if (getDataResponse.statusCode == 200) {
        final Map<String, dynamic> dataTawaran =
            json.decode(getDataResponse.body);
        int idTawaran = dataTawaran.length + 1;
        print('idTaawran : $idTawaran');
        String tawaran = 'tawaran$idTawaran';

        // Buat data JSON untuk dikirim ke Firebase
        Map<String, dynamic> data = {
          'id_tawaran': tawaran,
          'asal_perusahaan': widget.data,
          'nama_project': jobTitle,
          'deskripsi': description,
          'skill': requirements,
          'kuota_terima': kuota,
          'sudah_diterima': 0,
          'username': company,
          'waktu': waktu,
          'status_approval': 0
        };

        // URL Firebase Database untuk menyimpan data baru
        final postUrl = Uri.https(
          'ambw-leap-default-rtdb.firebaseio.com',
          'dataTawaran/$tawaran.json',
        );

        // Kirim data ke Firebase
        final postResponse = await http.put(
          postUrl,
          body: json.encode(data),
        );

        if (postResponse.statusCode == 200) {
          // Berhasil menyimpan data
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form submitted successfully!')),
          );

          // Clear the text fields
          _companyController.clear();
          _jobTitleController.clear();
          _descriptionController.clear();
          _requirementsController.clear();
          _kuotaController.clear();

          print('dataTawaran length: ${dataTawaran.length}');
        } else {
          // Gagal menyimpan data
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit form. Please try again.')),
          );
        }
      } else {
        print('Failed to fetch data for length calculation.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(
                  labelText: 'Nama Perusahaan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(
                  labelText: 'Judul Projek',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _requirementsController,
                decoration: InputDecoration(
                  labelText: 'Requirements',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the requirements';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _kuotaController,
                decoration: InputDecoration(
                  labelText: 'Kuota',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ajukan rentang kuota';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _waktucontroller,
                decoration: InputDecoration(
                  labelText: 'waktu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ajukan rentang kuota';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ajukan approval'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
