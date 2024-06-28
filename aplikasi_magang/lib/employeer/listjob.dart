import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'detail_job.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Listjob extends StatefulWidget {
  final String Username_p;
  const Listjob({required this.Username_p, super.key});
  // const Listjob({super.key});

  @override
  State<Listjob> createState() => _ListjobState();
}

class _ListjobState extends State<Listjob> {
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

      print("Total data items: ${data.length}");
      print("data mentah $data ");

      data.forEach((key, value) {
        print("Processing item with key: $key and value: $value");
        if (value['asal_perusahaan'] == widget.Username_p &&
            value['status_approval'] == 1 &&
            value['sudah_diterima'] < value['kuota_terima']) {
          filteredData.add(value as Map<String, dynamic>);
        }
      });

      setState(() {
        _filteredData = filteredData;
      });

      print('Data berhasil diambil dan difilter: $_filteredData');
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailJob(
                        jobTitle: item['nama_project'].toString(),
                        description: item['deskripsi'].toString(),
                        requirements: item['requirements']?.toString() ??
                            'No requirements',
                        tanggal_akhir_rekrut:
                            item['tanggal_akhir_rekrut'].toString(),
                        tanggal_mulai_rekrut:
                            item['tanggal_mulai_rekrut'].toString(),
                        tanggal_pelaksanaan:
                            item['tanggal_pelaksanaan'].toString(),
                        tanggal_update_tawaran:
                            item['tanggal_update_tawaran'].toString(),
                        waktu: item['waktu'].toString(),
                        min_ipk: item['min_ipk'],
                        jenis: item['jenis'].toString(),
                        id_tawaran: item['id_tawaran'].toString(),
                        get_username: widget.Username_p,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width according to screen size
                    constraints: BoxConstraints(maxWidth: 800),
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
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Add padding to the container
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0), // Add padding to the left
                            child: Text(
                              item['nama_project'].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0), // Add padding to the left
                            child: Text(
                                "Kuota: ${item['kuota_terima'].toString()}"), // Assuming there is a 'kuota' field
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0), // Add padding to the left
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align text and button to the left
                              children: [
                                Text(
                                  item['deskripsi'].toString(),
                                  maxLines: 3, // Limit to 3 lines
                                  overflow: TextOverflow
                                      .ellipsis, // Ellipsis for overflow
                                ),
                                SizedBox(
                                    height:
                                        10), // Add some space between the text and the button
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailJob(
                                          jobTitle:
                                              item['nama_project'].toString(),
                                          description:
                                              item['deskripsi'].toString(),
                                          requirements: item['requirements']
                                                  ?.toString() ??
                                              'No requirements',
                                          tanggal_akhir_rekrut:
                                              item['tanggal_akhir_rekrut']
                                                  .toString(),
                                          tanggal_mulai_rekrut:
                                              item['tanggal_mulai_rekrut']
                                                  .toString(),
                                          tanggal_pelaksanaan:
                                              item['tanggal_pelaksanaan']
                                                  .toString(),
                                          tanggal_update_tawaran:
                                              item['tanggal_update_tawaran']
                                                  .toString(),
                                          waktu: item['waktu'].toString(),
                                          min_ipk: item['min_ipk'],
                                          jenis: item['jenis'].toString(),
                                          id_tawaran:
                                              item['id_tawaran'].toString(),
                                          get_username: widget.Username_p,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('See details'),
                                ),
                              ],
                            ),
                          ),
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
