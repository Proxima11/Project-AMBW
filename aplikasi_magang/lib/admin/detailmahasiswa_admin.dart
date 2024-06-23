import 'package:flutter/material.dart';
import 'package:aplikasi_magang/admin/statustawaranmahasiswa_admin.dart';

class DetailmahasiswaAdmin extends StatefulWidget {
  final String profilePicture;
  final String nama;
  final String nrp;
  final String indexScore;

  DetailmahasiswaAdmin({
    required this.profilePicture,
    required this.nama,
    required this.nrp,
    required this.indexScore,
    super.key,
  });

  @override
  _DetailmahasiswaAdminState createState() => _DetailmahasiswaAdminState();
}

class _DetailmahasiswaAdminState extends State<DetailmahasiswaAdmin> {
  List<List<String>> _datamagang = [
    ["C1421001", "Project 1", "Perusahaan 1", "1"],
    ["C1421002", "Project 2", "Perusahaan 2", "2"],
    ["C1421010", "Project 3", "Perusahaan 3", "1"],
    ["C1421015", "Project 4", "Perusahaan 4", "4"],
  ];

  List<List<String>> getFilteredData() {
    return _datamagang.where((data) => data[0] == widget.nrp).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> filteredData = getFilteredData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nama,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'NRP : ${widget.nrp}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'IPK : ${widget.indexScore}',
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
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return StatusTawaranMahasiswaAdmin(
                      nrp: filteredData[index][0],
                      namaProject: filteredData[index][1],
                      namaPerusahaan: filteredData[index][2],
                      status: filteredData[index][3],
                      onStatusChanged: (newValue) {
                        setState(() {
                          _datamagang[index][3] = getStatusValue(newValue);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getStatusValue(String text) {
    switch (text) {
      case 'Applied':
        return '1';
      case 'Interviewed':
        return '2';
      case 'Approved':
        return '3';
      case 'Rejected':
        return '4';
      case 'Canceled':
        return '5';
      default:
        return 'Unknown';
    }
  }
}

