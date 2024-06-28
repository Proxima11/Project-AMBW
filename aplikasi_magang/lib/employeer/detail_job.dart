import 'package:flutter/material.dart';
import 'applicant_detailjob.dart';

class DetailJob extends StatelessWidget {
  final String? jobTitle;
  final String? description;
  final String? requirements;
  final String? tanggal_akhir_rekrut;
  final String? tanggal_mulai_rekrut;
  final String? tanggal_pelaksanaan;
  final String? tanggal_update_tawaran;
  final String? waktu;
  final int? min_ipk;
  final String? jenis;
  final String? id_tawaran;
  final String? get_username;

  const DetailJob(
      {Key? key,
      this.jobTitle,
      this.description,
      this.requirements,
      this.tanggal_akhir_rekrut,
      this.tanggal_mulai_rekrut,
      this.tanggal_pelaksanaan,
      this.tanggal_update_tawaran,
      this.waktu,
      this.min_ipk,
      this.id_tawaran,
      this.jenis,
      this.get_username})
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
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // Adjust width according to screen size
              constraints:
                  BoxConstraints(maxWidth: 700), // Max width for larger screens
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle ?? 'null',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Text(
                    //   'id_tawaran : ${id_tawaran ?? 'null'}',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(height: 5),
                    Text(
                      description ?? 'null',
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
                      requirements ?? 'null',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Minimal ipk : ${min_ipk?.toString() ?? 'null'}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lama waktu : ${waktu ?? 'null'}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'jenis : ${jenis ?? 'null'}',
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
                              id_tawaran: id_tawaran ?? 'null',
                              get_username: get_username ?? 'null',
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
                          fontSize: 25,
                        ),
                      ),
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
