import 'package:flutter/material.dart';
import 'detail_selected_magang.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './mahasiswa_operation.dart';

class leap_mhs extends StatefulWidget {
  final String studentId;
  leap_mhs({required this.studentId});
  @override
  State<leap_mhs> createState() => _leap_mhsState();
}

class _leap_mhsState extends State<leap_mhs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('LEAP'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            AktifTable(
              status: 0,
              studentId: widget.studentId,
            ),
            SelesaiTable(
              status: 1,
              studentId: widget.studentId,
            ),
          ],
        ),
      ),
    );
  }
}

class AktifTable extends StatefulWidget {
  final int status;
  final String studentId;
  AktifTable({required this.status, required this.studentId});
  @override
  State<AktifTable> createState() => _AktifTableState();
}

class _AktifTableState extends State<AktifTable> {
  List<DataRow> rows = [];
  late List<Mahasiswa> choosenMhs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
      );

      if (response.statusCode == 200 && widget.studentId != "null") {
        final Map<String, dynamic> data = json.decode(response.body);
        Mahasiswa? selectedMahasiswa;

        data.forEach((key, value) {
          final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
          if (mahasiswa.nrp == widget.studentId) {
            selectedMahasiswa = mahasiswa;
          }
        });

        if (selectedMahasiswa != null) {
          setState(() {
            choosenMhs.add(selectedMahasiswa!);
          });
          await _fetchData();
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (data.status == 1 && project.statusTawaran == 2) {
            filteredTawaranProjects.add(project);
            filteredTawaran
                .add(project.idTawaran); // Populate filteredTawaranIds
          }
        } catch (e) {
          print('Error parsing TawaranProject from JSON: $e');
          // Handle parsing error (e.g., log it, skip this project, etc.)
        }
      });

      List<Map<String, dynamic>> tawaranData =
          await fetchDataTawaran(filteredTawaran);

      setState(() {
        rows = tawaranData.asMap().entries.map((entry) {
          int index = entry.key;
          var tawaran = entry.value;
          int index_display = index + 1;

          return DataRow(
            cells: [
              DataCell(Text(
                  "$index_display")), // Example of using index as a cell value// Replace "test" with actual data you want to display
              DataCell(Text(data.username)),
              DataCell(Text(data.nrp)),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['nama_pembimbing'] ?? ' ')),
              DataCell(Text(tawaran['nama_mentor'] ?? ' ')),
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
              DataCell(Text(data.status == 1
                  ? 'Aktif'
                  : (data.status == null ? ' ' : 'Tidak Aktif'))),
              // DataCell(
              //   Expanded(
              //     child: SizedBox(
              //       width: double.infinity,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => detail_selected_magang(
              //                       idTawaran: filteredTawaranProjects[index]
              //                           .idTawaran
              //                           .toString(),
              //                       studentId: widget.studentId.toString(),
              //                       nama_mahasiswa: data.username.toString(),
              //                       nama_pembimbing:
              //                           filteredTawaranProjects[index]
              //                               .namaPembimbing
              //                               .toString(),
              //                       nama_mentor: filteredTawaranProjects[index]
              //                           .namaMentor
              //                           .toString(),
              //                       nama_mitra:
              //                           tawaran['asal_perusahaan'].toString(),
              //                       judul: tawaran['nama_project'].toString(),
              //                     )),
              //           );
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.blue,
              //           shape: RoundedRectangleBorder(
              //             borderRadius:
              //                 BorderRadius.circular(0), // Rectangle shape
              //           ),
              //           padding: EdgeInsets.all(
              //               0), // Remove padding to fill the cell
              //         ),
              //         child: Icon(Icons.search, color: Colors.white),
              //       ),
              //     ),
              //   ),
              // )
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataTawaran(
      List<String> filteredTawaran) async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> tawaranList = [];

      data.forEach((key, value) {
        if (filteredTawaran.contains(value['id_tawaran'])) {
          tawaranList.add(value);
        }
      });
      print(tawaranList[0]);

      return tawaranList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            // DataCell(Text('-')),
          ],
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  border: TableBorder.all(
                    width: 2.0,
                    color: Colors.grey,
                  ),
                  columns: [
                    DataColumn(
                        label: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Nama',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('NRP',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Judul',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Nama Pembimbing',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mentor',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    // DataColumn(
                    //     label: Text('Aksi',
                    //         style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: rows, // No data available
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelesaiTable extends StatefulWidget {
  final int status;
  final String studentId;
  SelesaiTable({required this.status, required this.studentId});
  @override
  State<SelesaiTable> createState() => _SelesaiTableState();
}

class _SelesaiTableState extends State<SelesaiTable> {
  List<DataRow> rows = [];
  late List<Mahasiswa> choosenMhs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
      );

      if (response.statusCode == 200 && widget.studentId != "null") {
        final Map<String, dynamic> data = json.decode(response.body);
        Mahasiswa? selectedMahasiswa;

        data.forEach((key, value) {
          final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
          if (mahasiswa.nrp == widget.studentId) {
            selectedMahasiswa = mahasiswa;
          }
        });

        if (selectedMahasiswa != null) {
          setState(() {
            choosenMhs.add(selectedMahasiswa!);
          });
          await _fetchData();
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 5) {
            filteredTawaranProjects.add(project);
            filteredTawaran
                .add(project.idTawaran); // Populate filteredTawaranIds
          }
        } catch (e) {
          print('Error parsing TawaranProject from JSON: $e');
          // Handle parsing error (e.g., log it, skip this project, etc.)
        }
      });

      List<Map<String, dynamic>> tawaranData =
          await fetchDataTawaran(filteredTawaran);

      setState(() {
        rows = tawaranData.asMap().entries.map((entry) {
          int index = entry.key;
          var tawaran = entry.value;
          int index_display = index + 1;

          return DataRow(
            cells: [
              DataCell(Text(
                  "$index_display")), // Example of using index as a cell value// Replace "test" with actual data you want to display
              DataCell(Text(data.username)),
              DataCell(Text(data.nrp)),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(
                  filteredTawaranProjects[index].namaPembimbing.toString() ??
                      ' ')),
              DataCell(Text(
                  filteredTawaranProjects[index].namaMentor.toString() ?? ' ')),
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
              DataCell(Text(filteredTawaranProjects[index].statusTawaran == 5
                  ? 'Selesai'
                  : (data.status == null ? ' ' : 'Tidak Aktif'))),
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataTawaran(
      List<String> filteredTawaran) async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> tawaranList = [];

      data.forEach((key, value) {
        if (filteredTawaran.contains(value['id_tawaran'])) {
          tawaranList.add(value);
        }
      });
      // print(tawaranList[0]);

      return tawaranList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            DataCell(Text('-')),
            // DataCell(Text('-')),
          ],
        ),
      );
    }
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  border: TableBorder.all(
                    width: 2.0,
                    color: Colors.grey,
                  ),
                  columns: [
                    DataColumn(
                        label: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Nama',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('NRP',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Judul',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Nama Pembimbing',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mentor',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    // DataColumn(
                    //     label: Text('Aksi',
                    //         style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: rows, // No data available
                ),
              )),
        ),
      );
    });
  }
}
