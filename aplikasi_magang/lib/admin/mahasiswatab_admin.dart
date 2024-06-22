import 'package:flutter/material.dart';
import 'mahasiswacard_admin.dart';

class MahasiswaTabAdmin extends StatefulWidget {
  MahasiswaTabAdmin({super.key});

  @override
  _MahasiswaTabAdminState createState() => _MahasiswaTabAdminState();
}

class _MahasiswaTabAdminState extends State<MahasiswaTabAdmin> {
  final List<List<String>> _mahasiswa = [
    ["Mahasiswa1", "NRP 1", "Profile 1", "Index 1"],
    ["Mahasiswa2", "NRP 2", "Profile 2", "Index 2"],
    ["Mahasiswa3", "NRP 3", "Profile 3", "Index 3"],
  ];

  late List<List<String>> _filteredMahasiswa;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMahasiswa = _mahasiswa;
    _searchController.addListener(_filterMahasiswa);
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
      _filteredMahasiswa = _mahasiswa.where((student) {
        return student[0].toLowerCase().contains(query) ||
               student[1].toLowerCase().contains(query) ||
               student[2].toLowerCase().contains(query) ||
               student[3].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahasiswa Admin'),
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
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMahasiswa.length,
              itemBuilder: (context, index) {
                return MahasiswaCard(
                  profilePicture: _filteredMahasiswa[index][2],
                  nama: _filteredMahasiswa[index][0],
                  nrp: _filteredMahasiswa[index][1],
                  indexScore: _filteredMahasiswa[index][3],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
