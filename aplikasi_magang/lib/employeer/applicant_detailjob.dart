import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'StudentProfiePage.dart';

class ApplicantDetailjob extends StatefulWidget {
  final String jobTitle;
  final String description;
  final String requirements;
  final String id_tawaran;
  final String get_username;

  const ApplicantDetailjob(
      {super.key,
      required this.jobTitle,
      required this.description,
      required this.requirements,
      required this.id_tawaran,
      required this.get_username});

  @override
  State<ApplicantDetailjob> createState() => _ApplicantDetailjobState();
}

class _ApplicantDetailjobState extends State<ApplicantDetailjob> {
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirebase();
  }

  Future<void> _fetchDataFromFirebase() async {
    final urlMahasiswa = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa.json',
    );

    final urlTawaran = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran.json',
    );

    try {
      final responseMahasiswa = await http.get(urlMahasiswa);
      final responseTawaran = await http.get(urlTawaran);

      if (responseMahasiswa.statusCode == 200 &&
          responseTawaran.statusCode == 200) {
        final Map<String, dynamic> dataMahasiswa =
            json.decode(responseMahasiswa.body);
        final Map<String, dynamic> dataTawaran =
            json.decode(responseTawaran.body);

        // Check if the provided id_tawaran exists in dataTawaran
        if (dataTawaran.containsKey(widget.id_tawaran)) {
          final List<Map<String, dynamic>> filteredData = [];

          dataMahasiswa.forEach((key, value) {
            if (value['status'] == 1 && value['tawaranPilihan'] != null) {
              value['tawaranPilihan'].forEach((tawaranKey, tawaranValue) {
                final idTawaranMahasiswa = tawaranValue['id_tawaran'];
                if (idTawaranMahasiswa == widget.id_tawaran &&
                    tawaranValue['status_tawaran'] == 2) {
                  final tawaranData = dataTawaran[idTawaranMahasiswa];
                  if (tawaranData['asal_perusahaan'] == widget.get_username) {
                    filteredData.add({
                      'username': value['username'],
                      'nama_project': dataTawaran[widget.id_tawaran]
                          ['nama_project'],
                      'index_score': value['indexPrestasi'],
                      'id_tawaran': tawaranData['id_tawaran']
                    });
                  }
                }
              });
            }
          });

          setState(() {
            _filteredData = filteredData;
          });

          print(
              'Data filtered with id_tawaran = ${widget.id_tawaran}: $_filteredData');
        } else {
          print('The provided id_tawaran does not exist in dataTawaran');
        }
      } else {
        print(
            'Failed to fetch data from Firebase. Mahasiswa status code: ${responseMahasiswa.statusCode}, Tawaran status code: ${responseTawaran.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _updateDataFromFirebase(
      String idTawaranYangDiKlik, int condition, String username) async {
    final urlMahasiswa = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa.json',
    );

    final urlTawaran = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran/$idTawaranYangDiKlik.json',
    );

    try {
      final responseMahasiswa = await http.get(urlMahasiswa);
      final responseTawaran = await http.get(urlTawaran);

      if (responseMahasiswa.statusCode == 200 &&
          responseTawaran.statusCode == 200) {
        final Map<String, dynamic> dataMahasiswa =
            json.decode(responseMahasiswa.body);
        final Map<String, dynamic> tawaranData =
            json.decode(responseTawaran.body);

        int currentSudahDiterima = tawaranData['sudah_diterima'] ?? 0;

        dataMahasiswa.forEach((key, value) async {
          if (value['tawaranPilihan'] != null &&
              value['username'] == username) {
            bool accepted = false;

            if (condition == 0) {
              value['status'] = 1;
            }

            value['tawaranPilihan'].forEach((tawaranKey, tawaranValue) async {
              final idTawaranMahasiswa = tawaranValue['id_tawaran'];
              if (idTawaranMahasiswa == idTawaranYangDiKlik &&
                  tawaranData['asal_perusahaan'] == 'PT SINAR ABADI') {
                // Update status tawaran dalam tawaranPilihan
                if (condition == 0) {
                  tawaranValue['status_tawaran'] = 2;
                  tawaranData['sudah_diterima'] = currentSudahDiterima + 1;
                  accepted = true;
                } else if (condition == 1) {
                  tawaranValue['status_tawaran'] = 3;
                }

                // Update dataMahasiswa di Firebase
                final updateUrlMahasiswa = Uri.https(
                  'ambw-leap-default-rtdb.firebaseio.com',
                  'dataMahasiswa/$key.json',
                );

                await http.patch(updateUrlMahasiswa, body: json.encode(value));

                // Update dataTawaran di Firebase
                final updateUrlTawaran = Uri.https(
                  'ambw-leap-default-rtdb.firebaseio.com',
                  'dataTawaran/$idTawaranMahasiswa.json',
                );

                await http.patch(updateUrlTawaran,
                    body: json.encode(tawaranData));
              }
            });

            // Jika tawaran diterima, ubah semua tawaran lain menjadi 3
            if (accepted) {
              value['tawaranPilihan'].forEach((tawaranKey, tawaranValue) async {
                final idTawaranMahasiswa = tawaranValue['id_tawaran'];
                if (idTawaranMahasiswa != idTawaranYangDiKlik) {
                  tawaranValue['status_tawaran'] = 3;

                  // Update dataMahasiswa di Firebase
                  final updateUrlMahasiswa = Uri.https(
                    'ambw-leap-default-rtdb.firebaseio.com',
                    'dataMahasiswa/$key.json',
                  );

                  await http.patch(updateUrlMahasiswa,
                      body: json.encode(value));
                }
              });
            }
          }
        });

        // Debug log
        print('Data updated for tawaran from PT SINAR ABADI.');
      } else {
        print(
            'Failed to fetch data from Firebase. Mahasiswa status code: ${responseMahasiswa.statusCode}, Tawaran status code: ${responseTawaran.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Homepage'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: _filteredData.map((student) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfilePage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/profilepic.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            student['username'] ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Index score : ${student['index_score'] ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Projek yang dilamar : ${student['nama_project'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'id_tawaran : ${student['id_tawaran'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentProfilePage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'See more detail in here',
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle the Accepted button press
                                                _updateDataFromFirebase(
                                                    '${student['id_tawaran']}',
                                                    0,
                                                    '${student['username']}');
                                              },
                                              child: Text('Accept'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Handle the Rejected button press
                                                _updateDataFromFirebase(
                                                    '${student['id_tawaran']}',
                                                    1,
                                                    '${student['username']}');
                                              },
                                              child: Text('Reject'),
                                            ),
                                          ],
                                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
