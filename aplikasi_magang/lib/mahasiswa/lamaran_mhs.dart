// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './mahasiswa_operation.dart';

class lamaran_mhs extends StatefulWidget {
  final String studentId;
  lamaran_mhs({required this.studentId});
  @override
  State<lamaran_mhs> createState() => _lamaran_mhsState();
}

class _lamaran_mhsState extends State<lamaran_mhs> {
  late Future<List<Map<String, dynamic>>> futureData;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lamaran'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Waiting'),
              Tab(text: 'Interview'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            LamaranTable(
              status: 0,
              studentId: widget.studentId,
            ),
            InterviewTable(
              status: 1,
              studentId: widget.studentId,
            ),
            ApprovedTable(
              status: 2,
              studentId: widget.studentId,
            ),
            RejectedTable(
              status: 3,
              studentId: widget.studentId,
            ),
            CancelledTable(
              status: 4,
              studentId: widget.studentId,
            )
          ],
        ),
      ),
    );
  }
}

class LamaranTable extends StatefulWidget {
  final int status;
  final String studentId;
  LamaranTable({required this.status, required this.studentId});

  @override
  State<LamaranTable> createState() => _LamaranTableState();
}

class _LamaranTableState extends State<LamaranTable> {
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

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 0) {
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
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['jenis'] ?? ' ')),
              DataCell(
                  Text(filteredTawaranProjects[index].tanggalUpdate ?? 'test')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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

class InterviewTable extends StatefulWidget {
  final int status;
  final String studentId;
  InterviewTable({required this.status, required this.studentId});

  @override
  State<InterviewTable> createState() => _InterviewTableState();
}

class _InterviewTableState extends State<InterviewTable> {
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

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 1) {
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
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['jenis'] ?? ' ')),
              DataCell(
                  Text(filteredTawaranProjects[index].tanggalUpdate ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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

class ApprovedTable extends StatefulWidget {
  final int status;
  final String studentId;
  ApprovedTable({required this.status, required this.studentId});

  @override
  State<ApprovedTable> createState() => _ApprovedTableState();
}

class _ApprovedTableState extends State<ApprovedTable> {
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

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 2) {
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
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['jenis'] ?? 'test')),
              DataCell(
                  Text(filteredTawaranProjects[index].tanggalUpdate ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
              DataCell(
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IntrinsicWidth(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height:
                                                  10), // Adjusted space for the X button
                                          Text(
                                            'Terima Lamaran',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Apakah anda ingin untuk menerima magang ini?',
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            'Anda hanya bisa sekali untuk menerima magang. Tawaran magang lainnya akan tertolak.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Approve action
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Reject',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Approve action
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Approve',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // Rectangle shape
                        ),
                        padding: EdgeInsets.all(
                            0), // Remove padding to fill the cell
                      ),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Aksi',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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

class RejectedTable extends StatefulWidget {
  final int status;
  final String studentId;
  RejectedTable({required this.status, required this.studentId});

  @override
  State<RejectedTable> createState() => _RejectedTableState();
}

class _RejectedTableState extends State<RejectedTable> {
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

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 3) {
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
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['jenis'] ?? ' ')),
              DataCell(
                  Text(filteredTawaranProjects[index].tanggalUpdate ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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

class CancelledTable extends StatefulWidget {
  final int status;
  final String studentId;
  CancelledTable({required this.status, required this.studentId});

  @override
  State<CancelledTable> createState() => _CancelledTableState();
}

class _CancelledTableState extends State<CancelledTable> {
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

  Future<void> _fetchData() async {
    try {
      final data = choosenMhs[0];
      List<String> filteredTawaran = [];
      final Map<String, dynamic> applications = data.tawaranPilihan;

      List<TawaranProject> filteredTawaranProjects = [];

      applications.forEach((key, value) {
        try {
          TawaranProject project = value;
          if (project.statusTawaran == 4) {
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
              DataCell(Text(tawaran['asal_perusahaan'] ?? ' ')),
              DataCell(Text(tawaran['nama_project'] ?? ' ')),
              DataCell(Text(tawaran['jenis'] ?? ' ')),
              DataCell(
                  Text(filteredTawaranProjects[index].tanggalUpdate ?? ' ')),
              DataCell(Text(tawaran['periode'] ?? ' ')),
            ],
          );
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
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
