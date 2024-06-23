import 'package:aplikasi_magang/admin/models/tawaranprojectModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:aplikasi_magang/admin/models/mahasiswaModel.dart'; // Import your Mahasiswa model

class MahasiswadalamtawaranAdmin extends StatefulWidget {
  final String id_tawaran;

  const MahasiswadalamtawaranAdmin({required this.id_tawaran, Key? key}) : super(key: key);

  @override
  State<MahasiswadalamtawaranAdmin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MahasiswadalamtawaranAdmin> {
  List<Mahasiswa> _filteredMahasiswa = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic>? data = json.decode(response.body);

    if (data != null) {
      print('Fetched data: $data'); // Print fetched data
      setState(() {
        _filteredMahasiswa = data.values
            .map((e) => Mahasiswa.fromJson(e))
            .where((mahasiswa) =>
                mahasiswa.tawaranPilihan.containsKey(widget.id_tawaran))
            .toList();
        _isLoading = false;
      });
    } else {
      print('No data available');
    }
  } else {
    print('Failed to load data. Status code: ${response.statusCode}');
    throw Exception('Failed to load data');
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 10,
            ),
            itemCount: _filteredMahasiswa.length,
            itemBuilder: (context, index){
              final mahasiswa = _filteredMahasiswa[index];
              final tawaranPilihan = mahasiswa.tawaranPilihan[widget.id_tawaran];
              return Text(tawaranPilihan?.id_tawaran ?? "tidak ada");
            }
          ),
        ),
      ),
    );
  }
}
