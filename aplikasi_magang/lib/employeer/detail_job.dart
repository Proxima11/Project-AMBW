import 'package:flutter/material.dart';
import 'applicant_detailjob.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailJob extends StatelessWidget {
  final String jobTitle;
  final String description;
  final String requirements;
  final String tanggal_akhir_rekrut;
  final String tanggal_mulai_rekrut;
  final String tanggal_pelaksanaan;
  final String tanggal_update_tawaran;
  final String waktu;
  final int min_ipk;
  final String jenis;
  final String id_tawaran;

  const DetailJob(
      {Key? key,
      required this.jobTitle,
      required this.description,
      required this.requirements,
      required this.tanggal_akhir_rekrut,
      required this.tanggal_mulai_rekrut,
      required this.tanggal_pelaksanaan,
      required this.tanggal_update_tawaran,
      required this.waktu,
      required this.min_ipk,
      required this.id_tawaran,
      required this.jenis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Job Details')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 700,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'id_tawaran : $id_tawaran',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Requirements',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        requirements,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tanggal mulai rekrut : $tanggal_mulai_rekrut',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Tanggal akhir rekrut : $tanggal_akhir_rekrut',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Minimal ipk : $min_ipk',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lama waktu : $waktu',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'jenis : $jenis',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'tanggal pelaksanaan  : $tanggal_pelaksanaan',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicantDetailjob(
                                jobTitle: 'Job Title',
                                description: 'Description of the job',
                                requirements: 'Requirements for the job',
                                id_tawaran: id_tawaran,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "lihat siapa saja yang melamar disini",
                          style: TextStyle(
                              color: Colors.blue[200],
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
