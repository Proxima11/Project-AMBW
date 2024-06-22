import 'package:flutter/material.dart';

class detailPengumuman extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                      '18-07-2023',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Informasi dan Kebutuhan Leap (Flowchart & Laporan Leap)',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Rekan-rekan mahasiswa, berikut ini file terkait dengan Informasi dan Laporan Leap (Magang/Riset/Community) bisa diakses di link berikut ini:',
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'https://drive.google.com/drive/folders/1SO5fqmPmxG88jQrCw0L-WHNGpGY8XUzv',
                      style: TextStyle(color: Colors.blue),
                    ),
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
