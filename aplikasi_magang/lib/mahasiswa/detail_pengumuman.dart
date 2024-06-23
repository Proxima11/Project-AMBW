import 'package:flutter/material.dart';

class detailPengumuman extends StatefulWidget {
  final Map<String, dynamic> fetchData;

  detailPengumuman({required this.fetchData});

  @override
  State<detailPengumuman> createState() => _detailPengumumanState();
}

class _detailPengumumanState extends State<detailPengumuman> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String judul = widget.fetchData['value']['judul'].toString();
    String tanggal = widget.fetchData['value']['tanggal'].toString();
    String deskripsi = widget.fetchData['value']['deskripsi'].toString();
    if(judul == "null"){
      judul = " ";
    }
    if(tanggal == "null"){
      tanggal = " ";
    }
    if(deskripsi == "null"){
      deskripsi = " ";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman'),
        actions: [],
      ),
      body: Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: screenWidth,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tanggal,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      judul,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(deskripsi),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
