import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'detail_job.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListjobWaitingApproval extends StatefulWidget {
  const ListjobWaitingApproval({super.key});

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
        if (value['asal_perusahaan'] == 'PT SINAR ABADI' &&
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    width: 800,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: Offset(0, 5), // Offset of the shadow
                        ),
                      ], // Membuat sudut tumpul
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Add padding to the left
                          child: Text(
                            item['nama_project'],
                            style: TextStyle(color: Colors.black, fontSize: 34),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0), // Add padding to the left
                          child: Text(
                              "Kuota: ${item['kuota_terima']}"), // Assuming there is a 'kuota' field
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0), // Add padding to the left
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text and button to the left
                            children: [
                              Text(item['deskripsi']),
                              SizedBox(
                                  height:
                                      30), // Add some space between the text and the button
                            ],
                          ),
                        ),
                      ],
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
