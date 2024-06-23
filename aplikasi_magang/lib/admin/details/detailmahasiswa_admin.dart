import 'package:aplikasi_magang/admin/statuscard_admin.dart';
import 'package:aplikasi_magang/admin/models/tawaranprojectModel.dart';
import 'package:aplikasi_magang/admin/models/mahasiswaModel.dart';
import 'package:flutter/material.dart';

class DetailmahasiswaAdmin extends StatefulWidget {
  final Mahasiswa dataMahasiswa;
  final String ipk;

  const DetailmahasiswaAdmin({
    required this.dataMahasiswa,
    required this.ipk,
    Key? key,
  }) : super(key: key);

  @override
  _DetailmahasiswaAdminState createState() => _DetailmahasiswaAdminState();
}

class _DetailmahasiswaAdminState extends State<DetailmahasiswaAdmin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.dataMahasiswa.username,
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
                'NRP : ${widget.dataMahasiswa.nrp}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'IPK : ${widget.ipk}',
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
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.dataMahasiswa.tawaranPilihan.length,
                  itemBuilder: (context, tawaranIndex) {
                    TawaranProject tawaran = widget.dataMahasiswa.tawaranPilihan.values.toList()[tawaranIndex];
                    return StatusCardAdmin(
                      nrp: widget.dataMahasiswa.nrp,
                      id_tawaran: tawaran.idTawaran,
                      status_tawaran: tawaran.statusTawaran,
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
}
