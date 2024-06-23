import 'package:aplikasi_magang/admin/mahasiswadalamtawaran_admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailtawaranAdmin extends StatefulWidget {
  final String namaProject;
  final String namaPerusahaan;

  const DetailtawaranAdmin(
      {required this.namaProject, required this.namaPerusahaan, super.key});

  @override
  State<DetailtawaranAdmin> createState() => _DetailtawaranAdminState();
}

class _DetailtawaranAdminState extends State<DetailtawaranAdmin> {
  late List<Map<String, dynamic>> _allTawaran = [];
  late List<Map<String, dynamic>> _filteredTawaran = [];
  int jumlahTawaran = 0;
  bool _isLoading = true;
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          jumlahTawaran = data.length;
          _allTawaran = data.entries
              .map((e) => {'key': e.key, 'value': e.value})
              .toList();
          _filterTawaran(); // Apply the filter after fetching data
          _isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isEmpty = true;
      });
      print('Error fetching data: $e');
    }
  }

  void _filterTawaran() {
    final queryPerusahaan = widget.namaPerusahaan.toLowerCase();
    final queryProject = widget.namaProject.toLowerCase();
    setState(() {
      _filteredTawaran = _allTawaran.where((tawaran) {
        final namaProject =
            tawaran['value']['nama_project']?.toLowerCase() ?? '';
        final namaPerusahaan =
            tawaran['value']['asal_perusahaan']?.toLowerCase() ?? '';
        return namaPerusahaan.contains(queryPerusahaan) &&
            namaProject.contains(queryProject);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Project",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : _filteredTawaran.isEmpty
              ? Text('No data found')
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30),
                                      Text(
                                        'Nama Project: ${_filteredTawaran[0]['value']['nama_project']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Asal Perusahaan: ${_filteredTawaran[0]['value']['asal_perusahaan']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Tanggal Pelaksanaan: ${_filteredTawaran[0]['value']['tanggal_pelaksanaan']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 30),
                                      Text(
                                        'Kuota: ${_filteredTawaran[0]['value']['kuota_terima']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Min IPK: ${_filteredTawaran[0]['value']['min_ipk']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Periode: ${_filteredTawaran[0]['value']['waktu']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 10),
                                    ]),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Deskripsi: ${_filteredTawaran[0]['value']['deskripsi']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.center,
                            child: const Text(
                              'Data Magang Mahasiswa',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Text("Data belum ada")
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}