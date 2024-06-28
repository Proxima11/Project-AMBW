import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'editdatamahasiswa_admin.dart';

class DetailMahasiswaAdmin extends StatefulWidget {
  const DetailMahasiswaAdmin({super.key});

  @override
  State<DetailMahasiswaAdmin> createState() => _DetailMahasiswaAdminState();
}

class _DetailMahasiswaAdminState extends State<DetailMahasiswaAdmin> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchFromFirebase();
  }

  Future<void> _fetchFromFirebase() async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa.json',
    );

    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    final List<Map<String, dynamic>> loadedItems = [];
    data.forEach((key, value) {
      loadedItems.add({
        'id': key,
        'indexPrestasi': value['indexPrestasi'],
        'nrp': value['nrp'],
        'status': value['status'],
        'tawaranPilihan': value['tawaranPilihan'],
        'username': value['username'],
      });
    });

    setState(() {
      _items = loadedItems;
      _filteredItems = loadedItems;
    });
  }

  void _updateInFirebase(String id, Map<String, dynamic> newData) async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa/$id.json',
    );

    final response = await http.patch(
      url,
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode(newData),
    );
    debugPrint(response.body);
    debugPrint(response.statusCode.toString());
    _fetchData();
  }

  void _navigateToEditScreen(BuildContext context, Map<String, dynamic> item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditScreen(
          item: item,
          onSave: (newData) {
            if (newData['status_terima'] == true) {
              newData['status'] = 1;
            }
            _updateInFirebase(item['id'], newData);
          },
        ),
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = _items
          .where((item) =>
              item['username'].toLowerCase().contains(query.toLowerCase()) ||
              item['nrp'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int maxCrossAxisCount = 4;
    final int calculatedCrossAxisCount =
        MediaQuery.of(context).size.width ~/ 300;
    final int crossAxisCount = calculatedCrossAxisCount > maxCrossAxisCount
        ? maxCrossAxisCount
        : calculatedCrossAxisCount;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Data Mahasiswa')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari berdasarkan nama atau NRP',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterItems,
            ),
          ),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                double screenWidth = MediaQuery.of(context).size.width;
                double size;
                if (screenWidth * 0.2 > 100) {
                  size = 100;
                } else {
                  size = screenWidth * 0.2;
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (ctx, index) {
                    final item = _filteredItems[index];
                    final ipkFormatted;
                    if (item['indexPrestasi'] != null) {
                      ipkFormatted =
                          item['indexPrestasi'].toStringAsFixed(2).toString();
                    } else {
                      ipkFormatted = ipkFormatted = 'not assigned';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 150,
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
                        child: Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 100,
                                    child: Center(
                                      //child: Text("Profile Picture")
                                      child: Icon(
                                        Icons.account_circle,
                                        size: size,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, top: 10.0),
                                      child: Text(
                                        item['username'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['nrp'],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text('IPK: $ipkFormatted'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          _navigateToEditScreen(context, item);
                                        },
                                        child:
                                            const Text('Edit Data Mahasiswa'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}
