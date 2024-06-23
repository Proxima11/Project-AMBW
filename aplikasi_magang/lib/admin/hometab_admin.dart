import 'package:aplikasi_magang/admin/tawarancard_admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeTabAdmin extends StatefulWidget {
  const HomeTabAdmin({super.key});

  @override
  State<HomeTabAdmin> createState() => _HomeTabAdminState();
}

class _HomeTabAdminState extends State<HomeTabAdmin> {
  late List<Map<String, dynamic>> _allTawaran = [];
  late List<Map<String, dynamic>> _filteredTawaran = [];
  TextEditingController _searchController = TextEditingController();

  int jumlahTawaran = 0;

  var chosenTypeMagang;
  var chosenTypeSkill;
  var chosenLokasi;

  List<String> TypeMagangList = [
    "Industrial Experience (Magang)",
    "Community Engagement",
    "Research and Innovation"
  ];

  List<String> TypeSkillList = [
    "Business Intelligence",
    "Game Development",
    "Mobile Application (Android)",
    "Artificial Intelligence",
    "Mobile Application (IOS)",
    "Cyber Security",
    "Data Science & Analytics",
    "Enterprise Information System"
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTawaran);
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Data fetched: $data"); // Print fetched data
      setState(() {
        jumlahTawaran = data.length;
        _allTawaran = data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
        _filteredTawaran = List.from(_allTawaran); // Initialize filtered data
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTawaran);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTawaran() {
    final query = _searchController.text.toLowerCase();
    print("Search query: $query"); // Print search query
    setState(() {
      _filteredTawaran = _allTawaran.where((tawaran) {
        final namaProject = tawaran['value']['nama_project'].toLowerCase();
        return namaProject.contains(query);
      }).toList();
      print("Filtered results: $_filteredTawaran"); // Print filtered results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Data Mahasiswa')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTawaran.length,
              itemBuilder: (context, index) {
                final tawaran = _filteredTawaran[index]['value'];
                return TawaranCardAdmin(
                  namaProject: tawaran['nama_project'],
                  namaPerusahaan: tawaran['asal_perusahaan'],
                  deskripsi: tawaran['deskripsi'],
                  skill: tawaran['skill'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
