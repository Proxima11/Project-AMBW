import 'dart:io';
import 'package:aplikasi_magang/mahasiswa/homepage_mhs.dart';
import 'package:aplikasi_magang/mahasiswa/mahasiswa_operation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class detail_lamaran extends StatefulWidget {
  final Map<String, dynamic> fetchData;
  final String studentId;

  detail_lamaran({required this.fetchData, required this.studentId});

  @override
  State<detail_lamaran> createState() => _detail_lamaranState();
}

class _detail_lamaranState extends State<detail_lamaran> {
  bool isLoading = false;
  TextEditingController cvLinkController = TextEditingController();
  late DatabaseReference dbRef;
  late List<Mahasiswa> choosenMhs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
      );

      if (response.statusCode == 200 && widget.studentId != "null") {
        final Map<String, dynamic> data = json.decode(response.body);
        Mahasiswa? selectedMahasiswa;

        data.forEach((key, value) {
          final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
          if (mahasiswa.nrp == widget.studentId) {
            selectedMahasiswa = mahasiswa;
          }
        });

        if (selectedMahasiswa != null) {
          setState(() {
            choosenMhs.add(selectedMahasiswa!);
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  bool isValidURL(String url) {
    Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isAbsolute || uri.hasScheme);
  }

  void submitLamaran() async {
    String cvLink = cvLinkController.text;
    if (!isValidURL(cvLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }

    if (cvLink.isNotEmpty && choosenMhs.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
        );

        String? _key;

        if (response.statusCode == 200 && widget.studentId != "null") {
          final Map<String, dynamic> data = json.decode(response.body);
          Mahasiswa? selectedMahasiswa;
          data.forEach((key, value) {
            final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
            if (mahasiswa.nrp == widget.studentId) {
              _key = key;
            }
          });
        }
        ;

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('d/M/yyyy').format(now);
        String? id_taw;

        dbRef = FirebaseDatabase.instance
            .ref()
            .child('dataMahasiswa')
            .child(_key!)
            .child('tawaranPilihan')
            .child(widget.fetchData['value']['id_tawaran'].toString());

        await dbRef.set({
          'id_tawaran': widget.fetchData['value']['id_tawaran'].toString(),
          'nama_mentor': "",
          'nama_pembimbing': "",
          'status_tawaran': 0,
          'cvLink':
              cvLinkController.text, // Set the tanggal with the current date
          'tanggal_update': formattedDate, // Example timestamp
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lamaran berhasil diajukan')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan lamaran: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String jobTitle = widget.fetchData['value']['nama_project'].toString();
    String mitra = widget.fetchData['value']['asal_perusahaan'].toString();
    String tipe = widget.fetchData['value']['jenis'].toString();
    String tanggal_mulai_rekrut =
        widget.fetchData['value']['tanggal_mulai_rekrut'].toString();
    String tanggal_akhir_rekrut =
        widget.fetchData['value']['tanggal_akhir_rekrut'].toString();
    String tanggal_pelaksanaan =
        widget.fetchData['value']['tanggal_pelaksanaan'].toString();
    String lokasi = widget.fetchData['value']['lokasi'].toString();
    String min_ipk = widget.fetchData['value']['min_ipk'].toString();
    String description = widget.fetchData['value']['deskripsi'].toString();
    String kuotaTerima = widget.fetchData['value']['kuota_terima'].toString();
    String waktu = widget.fetchData['value']['waktu'].toString();
    String skill = widget.fetchData['value']['skill'].toString();
    String tanggal_pendaftaran = " ";

    if (jobTitle == "null") {
      jobTitle = " ";
    }
    if (mitra == "null") {
      mitra = " ";
    }
    if (tipe == "null") {
      tipe = " ";
    }
    if (tanggal_pelaksanaan == "null") {
      tanggal_pelaksanaan = " ";
    }
    if (lokasi == "null") {
      lokasi = " ";
    }
    if (min_ipk == "null") {
      min_ipk = "0.00 ";
    } else {
      min_ipk = double.parse(min_ipk).toStringAsFixed(2);
    }
    if (description == "null") {
      description = " ";
    }
    if (waktu == "null") {
      waktu = " ";
    }
    if (skill == "null") {
      skill = " ";
    }
    if (tanggal_pelaksanaan == "null") {
      tanggal_pelaksanaan = " ";
    }
    if (tanggal_mulai_rekrut == "null") {
      tanggal_mulai_rekrut = " ";
    }
    if (tanggal_akhir_rekrut == "null") {
      tanggal_akhir_rekrut = " ";
    }
    tanggal_pendaftaran = tanggal_mulai_rekrut + " s/d " + tanggal_akhir_rekrut;
    if (tanggal_pendaftaran == "  s/d  ") {
      tanggal_pendaftaran = " ";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Lamaran'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                // color: Colors.grey[300],
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            jobTitle, // Job Title from fetchData
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mitra : " + mitra, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Tipe Tawaran : " +
                                  tipe, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Tanggal Pendaftaran : " +
                                  tanggal_pendaftaran, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Tanggal Pelaksanaan : " +
                                  tanggal_pelaksanaan, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Lokasi : " + lokasi, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Kuota Terima : " +
                                  kuotaTerima, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Lama Magang : " +
                                  waktu, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Skill : " + skill, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Min IPK : " + min_ipk, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Deskripsi : " +
                                  description, // Job desk from fetchData
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Ajukan Lamaran'),
                        content: SingleChildScrollView(
                          child: Container(
                            child: Wrap(children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Nama: " +
                                              choosenMhs[0].username),
                                          Text("NRP: " + choosenMhs[0].nrp),
                                          Text("Email: " + choosenMhs[0].Email),
                                          Text("Program Studi: " +
                                              choosenMhs[0].programStudi),
                                          Text("IPK: " +
                                              choosenMhs[0]
                                                  .indexPrestasi
                                                  .toString()),
                                          Text(
                                            "No. Telp: " +
                                                (choosenMhs[0]
                                                            .NoHP
                                                            .toString()
                                                            .length >=
                                                        10
                                                    ? choosenMhs[0]
                                                        .NoHP
                                                        .toString()
                                                    : ""),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    controller: cvLinkController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      hintText: 'Link CV',
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              submitLamaran();
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Ajukan Lamaran'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
