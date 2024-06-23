import 'package:aplikasi_magang/admin/mahasiswacard_admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mahasiswaModel.dart';

class MahasiswaTabAdmin extends StatefulWidget {
  const MahasiswaTabAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MahasiswaTabAdminState createState() => _MahasiswaTabAdminState();
}

class _MahasiswaTabAdminState extends State<MahasiswaTabAdmin> {
  late List<Mahasiswa> _allMahasiswa = [];
  late List<Mahasiswa> _filteredMahasiswa = [];
  int jumlahMahasiswa = 0;

  final TextEditingController _searchController = TextEditingController();

  Future<List<Mahasiswa>> fetchData() async {
    final response = await http.get(
      Uri.parse('https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Mahasiswa> mahasiswaList = [];

      data.forEach((key, value) {
        final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
        mahasiswaList.add(mahasiswa);
      });

      return mahasiswaList;
    } else {
      throw Exception('Failed to load data');
    }
  } 


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterMahasiswa);
    fetchData().then((mahasiswaList) {
      setState(() {
        _allMahasiswa = mahasiswaList;
        _filteredMahasiswa = List.from(_allMahasiswa);
        jumlahMahasiswa = _allMahasiswa.length;
      });
    }).catchError((error) {
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMahasiswa);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMahasiswa() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMahasiswa = _allMahasiswa.where((mahasiswa) {
        return mahasiswa.username.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Data Mahasiswa')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 150,
                crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
                
                crossAxisSpacing: 5
              ),
              itemCount: _filteredMahasiswa.length,
              itemBuilder: (context, index) {
                final mahasiswa = _filteredMahasiswa[index];
                return MahasiswaCard(
                  dataMahasiswa: mahasiswa,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
