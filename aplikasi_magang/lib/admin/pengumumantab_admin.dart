import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'editpengumuman_admin.dart';
import 'addpengumuman_admin.dart';

void main() {
  runApp(PengumumanTabAdmin());
}

class PengumumanTabAdmin extends StatefulWidget {
  const PengumumanTabAdmin({super.key});

  @override
  State<PengumumanTabAdmin> createState() => _PengumumantabAdminState();
}

class _PengumumantabAdminState extends State<PengumumanTabAdmin> {
  List<Map<String, dynamic>> _items = [];
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
      'pengumuman.json',
    );

    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> loadedItems = [];
    data.forEach((key, value) {
      loadedItems.add({
        'id': key,
        'judul': value['judul'],
        'deskripsi': value['deskripsi'],
        'tanggal': value['tanggal'],
      });
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
        final judulPengumuman = item['judul'].toLowerCase();
        bool passesSearchFilter =
            query.isEmpty || judulPengumuman.contains(query.toLowerCase());
        return passesSearchFilter;
      }).toList();
    });
  }

  void _navigateToEditScreen(
      BuildContext context, Map<String, dynamic> item) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPengumumanScreen(item: item),
      ),
    );

    if (result == true) {
      _fetchData();
    }
  }

  void _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPengumumanScreen(),
      ),
    );

    if (result == true) {
      _fetchData();
    }
  }

  Future<void> _deleteItem(String id) async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'pengumuman/$id.json',
    );

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pengumuman'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari berdasarkan judul pengumuman',
                  border: OutlineInputBorder(),
                ),
                onChanged: _filterItems,
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // Ensure the container takes full width
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Ensure the inner container takes full width
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['judul'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 3, // Adjust maxLines as needed
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Tanggal Update : ${item['tanggal']}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () =>_navigateToEditScreen(context, item),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteItem(item['id']),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddScreen(context),
        child: Icon(Icons.add),
        tooltip: 'Add Pengumuman',
      ),
    );
  }
}
