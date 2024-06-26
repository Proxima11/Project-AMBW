import 'package:flutter/material.dart';
import 'package:aplikasi_magang/admin/models/mahasiswaModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EditScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic>) onSave;

  EditScreen({required this.item, required this.onSave});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Map<String, dynamic> tawaranPilihan;
  Map<String, dynamic> dataTawaran = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tawaranPilihan = Map<String, dynamic>.from(widget.item['tawaranPilihan']);
    _fetchTawaranData();
  }

  Future<void> _fetchTawaranData() async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran.json',
    );

    final response = await http.get(url);
    setState(() {
      dataTawaran = json.decode(response.body);
      isLoading = false;
    });
  }

  String getTawaranDetail(String idTawaran, String detail) {
    if (dataTawaran.containsKey(idTawaran)) {
      return dataTawaran[idTawaran][detail] ?? 'N/A';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.item['username'], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['username'], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'NRP : ${widget.item['nrp']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'IPK : ${widget.item['indexPrestasi']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            const Text(
              'Data Magang Mahasiswa',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tawaranPilihan.length,
                itemBuilder: (ctx, index) {
                  final key = tawaranPilihan.keys.elementAt(index);
                  final tawaran = tawaranPilihan[key];
                  final namaProject = getTawaranDetail(tawaran['id_tawaran'], 'nama_project');
                  final asalPerusahaan = getTawaranDetail(tawaran['id_tawaran'], 'asal_perusahaan');

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$namaProject',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '$asalPerusahaan',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Status Lamaran:',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DropdownButton<int>(
                                  value: tawaran['status_tawaran'],
                                  items: const [
                                    DropdownMenuItem(value: 0, child: Text('Applied')),
                                    DropdownMenuItem(value: 1, child: Text('Interview Process')),
                                    DropdownMenuItem(value: 2, child: Text('Accepted')),
                                    DropdownMenuItem(value: 3, child: Text('Rejected')),
                                    DropdownMenuItem(value: 4, child: Text('Canceled')),
                                  ],
                                  onChanged: (newValue) {
                                    setState(() {
                                      tawaran['status_tawaran'] = newValue!;
                                      tawaranPilihan[key] = tawaran;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newData = {
                  'tawaranPilihan': tawaranPilihan,
                };
                widget.onSave(newData);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
