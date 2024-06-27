import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aplikasi_magang/admin/detailtawaranaktif_admin.dart';

void main() {
  runApp(const HomeTabAdmin());
}

class HomeTabAdmin extends StatefulWidget {
  const HomeTabAdmin({super.key});

  @override
  State<HomeTabAdmin> createState() => _HomeTabAdminState();
}

class _HomeTabAdminState extends State<HomeTabAdmin> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _firstFilteredItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(() {
      _filterItems(_searchController.text);
    });
  }

  Future<void> _fetchData() async {
    await _fetchFromFirebase();
    setState(() {
      _filteredItems = List.from(
          _items); // Initialize _filteredItems with all items initially
    });
  }

  Future<void> _fetchFromFirebase() async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran.json',
    );

    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> loadedItems = [];
    data.forEach((key, value) {
      if (value['status_approval'].toString() == '1') {
        loadedItems.add({
          'id': key,
          'asal_perusahaan': value['asal_perusahaan'],
          'deskripsi': value['deskripsi'],
          'id_tawaran': value['id_tawaran'],
          'jenis': value['jenis'],
          'kuota_terima': value['kuota_terima'],
          'lokasi': value['lokasi'],
          'min_ipk': value['min_ipk'],
          'nama_project': value['nama_project'],
          'periode': value['periode'],
          'skill': value['skill'],
          'status': value['status'],
          'status_approval': value['status_approval'],
          'sudah_diterima': value['sudah_diterima'],
          'username': value['asal_perusahaan'],
          'waktu': value['waktu'],
          'tanggal_mulai_rekrut': value['tanggal_mulai_rekrut'],
          'tanggal_akhir_rekrut': value['tanggal_akhir_rekrut'],
          'tanggal_pelaksanaan': value['tanggal_pelaksanaan'],
        });
      }
    });

    setState(() {
      _items = loadedItems;
      _filteredItems =
          List.from(loadedItems); // Ensure _filteredItems is also initialized
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items.where((item) {
        final statusProject = item['status_approval'].toString();
        final namaProject = item['nama_project'].toLowerCase();
        final asalPerusahaan = item['asal_perusahaan'].toLowerCase();

        // First filter by status_approval == '1'
        bool passesStatusFilter = statusProject == '1';

        // Second filter by search query if provided
        bool passesSearchFilter = query.isEmpty ||
            (namaProject.contains(query.toLowerCase()) ||
                asalPerusahaan.contains(query.toLowerCase()));

        return passesStatusFilter && passesSearchFilter;
      }).toList();
    });
  }

  void _navigateToDetailScreen(
      BuildContext context, Map<String, dynamic> item) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailTawaranAktifAdmin(item: item),
      ),
    );

    // Check if result is true (meaning data was updated in DetailScreen)
    if (result == true) {
      // Refresh data
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int maxCrossAxisCount = 3;
    final int calculatedCrossAxisCount =
        MediaQuery.of(context).size.width ~/ 400;
    final int crossAxisCount = calculatedCrossAxisCount > maxCrossAxisCount
        ? maxCrossAxisCount
        : calculatedCrossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Data Tawaran')),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Cari berdasarkan nama project atau perusahaan',
                  border: OutlineInputBorder(),
                ),
                onChanged: _filterItems,
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 400,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 400, // Fixed maximum width
                            ),
                            child: Container(
                              height: 350,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _filteredItems[index]['nama_project'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _filteredItems[index]
                                              ['asal_perusahaan'],
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 30),
                                        Text(
                                          "Deskripsi : ${_filteredItems[index]['deskripsi']}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Skill : ${_filteredItems[index]['skill']}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          _navigateToDetailScreen(
                                              context, _filteredItems[index]);
                                        },
                                        child: const Text("Detail Tawaran"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
