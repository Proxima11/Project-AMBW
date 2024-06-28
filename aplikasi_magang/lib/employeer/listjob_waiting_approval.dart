import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'detail_job.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListjobWaitingApproval extends StatefulWidget {
  final String data;
  const ListjobWaitingApproval({required this.data, super.key});

  @override
  State<ListjobWaitingApproval> createState() => _ListjobState();
}

class _ListjobState extends State<ListjobWaitingApproval> {
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase(); // Fetch data saat aplikasi dimuat
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> _fetchDataFromFirebase() async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Berhasil mendapatkan data
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> filteredData = [];

      data.forEach((key, value) {
        if (value['asal_perusahaan'] == widget.data &&
            value['sudah_diterima'] < value['kuota_terima'] &&
            value['status_approval'] == 0) {
          filteredData.add(value as Map<String, dynamic>);
        }
      });

      setState(() {
        _filteredData = filteredData;
      });

      // Debug log
      // print('Data berhasil diambil dan difilter: $_filteredData');
    } else {
      // Gagal mendapatkan data
      print(
          'Gagal mendapatkan data dari Firebase. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _filteredData.map((item) {
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: BoxConstraints(maxWidth: 800),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5)
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Text(
                              item['nama_project'].toString(),
                              style: TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0),
                            child: Text(
                                "Kuota: ${item['kuota_terima'].toString()}"),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0),
                            child: Text(
                              item['deskripsi'].toString(),
                            ),
                          ),
                          SizedBox(height:10), // Add some space between the text and the button
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
