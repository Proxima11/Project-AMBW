import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssignPembimbingAdmin extends StatefulWidget {
  const AssignPembimbingAdmin({super.key});

  @override
  State<AssignPembimbingAdmin> createState() => _AssignPembimbingAdminState();
}

class _AssignPembimbingAdminState extends State<AssignPembimbingAdmin> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  Map<String, dynamic> _dataTawaran = {};
  List<String> _dosenUsernames = [];
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
    final urlMahasiswa = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa.json',
    );

    final urlTawaran = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataTawaran.json',
    );

    final urlDosen = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'account/dosen.json',
    );

    final responseMahasiswa = await http.get(urlMahasiswa);
    final responseTawaran = await http.get(urlTawaran);
    final responseDosen = await http.get(urlDosen);

    if (responseMahasiswa.statusCode == 200 &&
        responseTawaran.statusCode == 200 &&
        responseDosen.statusCode == 200) {
      final Map<String, dynamic> dataMahasiswa =
          json.decode(responseMahasiswa.body);
      final Map<String, dynamic> dataTawaran =
          json.decode(responseTawaran.body);
      final Map<String, dynamic> dataDosen = json.decode(responseDosen.body);

      final List<Map<String, dynamic>> loadedItems = [];
      dataMahasiswa.forEach((key, value) {
        if (value['status'] == 1) {
          loadedItems.add({
            'id': key,
            'indexPrestasi': value['indexPrestasi'],
            'nrp': value['nrp'],
            'status': value['status'],
            'tawaranPilihan': value['tawaranPilihan'],
            'username': value['username'],
          });
        }
      });

      final List<String> dosenUsernames = [];
      dataDosen.forEach((key, value) {
        dosenUsernames.add(value['username']);
      });

      setState(() {
        _items = loadedItems;
        _filteredItems = loadedItems;
        _dataTawaran = dataTawaran;
        _dosenUsernames = dosenUsernames;
      });
    } else {
      debugPrint(
          'Failed to load data: ${responseMahasiswa.statusCode}, ${responseTawaran.statusCode}, ${responseDosen.statusCode}');
    }
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

  String? getTawaranDetail(String idTawaran, String detail) {
    if (_dataTawaran.containsKey(idTawaran)) {
      return _dataTawaran[idTawaran][detail] ?? 'N/A';
    }
    return 'N/A';
  }

  void _updateNamaPembimbing(
      String idMahasiswa, String idTawaran, String namaPembimbing) async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa/$idMahasiswa/tawaranPilihan/$idTawaran.json',
    );

    final response = await http.patch(
      url,
      headers: {
        'Content-type': 'application/json',
      },
      body: json.encode({'nama_pembimbing': namaPembimbing}),
    );

    if (response.statusCode == 200) {
      debugPrint('Nama pembimbing updated successfully.');
    } else {
      debugPrint('Failed to update nama pembimbing: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Pembimbing'),
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
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (ctx, index) {
                final item = _filteredItems[index];
                String asalPerusahaan = '';
                String namaProject = '';
                String? selectedDosen;

                item['tawaranPilihan'].forEach((key, value) {
                  if (value['status_tawaran'] == 2) {
                    asalPerusahaan = getTawaranDetail(
                        value['id_tawaran'], 'asal_perusahaan')!;
                    namaProject =
                        getTawaranDetail(value['id_tawaran'], 'nama_project')!;
                    selectedDosen = value['nama_pembimbing'];
                  }
                });

                if (asalPerusahaan.isNotEmpty && namaProject.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['username'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                Text(item['nrp'], style: TextStyle(fontSize: 12, color: Colors.grey),),
                                SizedBox(height: 10,),
                                Text('Asal Perusahaan: $asalPerusahaan',style: TextStyle(fontSize: 15,),),
                                Text('Nama Projek: $namaProject',style: TextStyle(fontSize: 15,),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              hint: const Text('Pilih Pembimbing'),
                              value:
                                  selectedDosen == null || selectedDosen!.isEmpty
                                      ? 'belum ada pembimbing'
                                      : selectedDosen,
                              onChanged: (String? newValue) {
                                if (newValue != null &&
                                    newValue != 'belum ada pembimbing') {
                                  setState(() {
                                    selectedDosen = newValue;
                                    item['tawaranPilihan'].forEach((key, value) {
                                      if (value['status_tawaran'] == 2) {
                                        _updateNamaPembimbing(
                                            item['id'], key, selectedDosen!);
                                      }
                                    });
                                  });
                                }
                              },
                              items: [
                                const DropdownMenuItem<String>(
                                  value: 'belum ada pembimbing',
                                  child: Text('belum ada pembimbing'),
                                ),
                                ..._dosenUsernames.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // return ListTile(
                  //   title: Text(item['username']),
                  //   subtitle: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text('NRP: ${item['nrp']}'),
                  //       Text('Asal Perusahaan: $asalPerusahaan'),
                  //       Text('Nama Projek: $namaProject'),
                  //       DropdownButton<String>(
                  //         hint: const Text('Pilih Pembimbing'),
                  //         value: selectedDosen == null || selectedDosen!.isEmpty ? 'belum ada pembimbing' : selectedDosen,
                  //         onChanged: (String? newValue) {
                  //           if (newValue != null && newValue != 'belum ada pembimbing') {
                  //             setState(() {
                  //               selectedDosen = newValue;
                  //               item['tawaranPilihan'].forEach((key, value) {
                  //                 if (value['status_tawaran'] == 2) {
                  //                   _updateNamaPembimbing(item['id'], key, selectedDosen!);
                  //                 }
                  //               });
                  //             });
                  //           }
                  //         },
                  //         items: [
                  //           const DropdownMenuItem<String>(
                  //             value: 'belum ada pembimbing',
                  //             child: Text('belum ada pembimbing'),
                  //           ),
                  //           ..._dosenUsernames.map<DropdownMenuItem<String>>((String value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value,
                  //               child: Text(value),
                  //             );
                  //           }).toList(),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
