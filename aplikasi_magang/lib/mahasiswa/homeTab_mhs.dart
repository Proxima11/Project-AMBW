import 'package:aplikasi_magang/mahasiswa/mahasiswa_operation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import '../tools/dropdown.dart';
import '../tools/gridList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeTab extends StatefulWidget {
  final String studentId;
  HomeTab({required this.studentId});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  var chosenTypeMagang;
  var chosenTypeSkill;
  var chosenLokasi;

  List<String> TypeMagangList = [
    "Reset",
    "Industrial Experience (Magang)",
    "Community Engagement",
    "Research and Innovation"
  ];

  List<String> TypeSkillList = [
    "Reset",
    "Business Intelligence",
    "Game Development",
    "Mobile Application (Android)",
    "Artificial Intelligence",
    "Mobile Application (IOS)",
    "Cyber Security",
    "Data Science & Analytics",
    "Enterprise Information System"
  ];

  int jobCount = 0;
  late Future<List<Map<String, dynamic>>> futureData = Future.value([]);
  late Future<List<Map<String, dynamic>>> _allTawaran = Future.value([]);
  late Future<List<Map<String, dynamic>>> _filteredTawaran = Future.value([]);

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> allTawaran =
          data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
      setState(() {
        jobCount = data.length;
        _allTawaran = Future.value(allTawaran);
        _filteredTawaran = Future.value(allTawaran); // Initialize filtered data
      });
      late List<Mahasiswa> choosenMhs = [];

      final response_mhs = await http.get(
        Uri.parse(
            'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
      );
      if (response_mhs.statusCode == 200 && widget.studentId != "null") {
        final Map<String, dynamic> datamhs = json.decode(response_mhs.body);
        Mahasiswa? selectedMahasiswa;

        datamhs.forEach((key, value) {
          final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
          if (mahasiswa.nrp == widget.studentId) {
            selectedMahasiswa = mahasiswa;
          }
        });

        if (selectedMahasiswa != null) {
          setState(() {
            choosenMhs.add(selectedMahasiswa!);
          });
        }
        List<String> _filteredTawaranID = [];
        List<TawaranProject> filteredTawaranProjects = [];

        if (choosenMhs.isNotEmpty) {
          final Map<String, dynamic> applications =
              choosenMhs[0].tawaranPilihan;

          applications.forEach((key, value) {
            try {
              TawaranProject project = value;
              filteredTawaranProjects.add(project);
              _filteredTawaranID.add(project.idTawaran);
            } catch (e) {
              print('Error parsing TawaranProject from JSON: $e');
              // Handle parsing error (e.g., log it, skip this project, etc.)
            }

            List<Map<String, dynamic>> filteredTawaran = [];
            _filteredTawaran.then((tawaranList) {
              filteredTawaran = tawaranList
                  .where(
                      (tawaran) => !_filteredTawaranID.contains(tawaran['key']))
                  .toList();
              setState(() {
                _filteredTawaran = Future.value(filteredTawaran);
                jobCount = filteredTawaran.length;
              });
            });
          });
        }
        ;
      }

      return allTawaran;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> _filterTawaran(String query) async {
    final lowerCaseQuery = query.toLowerCase();
    final allTawaran = await _allTawaran;
    List<Map<String, dynamic>> filteredTawaran = allTawaran.where((tawaran) {
      final namaProject = tawaran['value']['nama_project'].toLowerCase();
      final typeMagang = tawaran['value']['jenis']?.toLowerCase() ?? '';
      final typeSkill = tawaran['value']['skill']?.toLowerCase() ?? '';
      final lokasi = tawaran['value']['lokasi']?.toLowerCase() ?? '';

      final matchesQuery = namaProject.contains(lowerCaseQuery);
      final matchesTypeMagang = chosenTypeMagang == null ||
          typeMagang.contains(chosenTypeMagang.toLowerCase());
      final matchesTypeSkill = chosenTypeSkill == null ||
          typeSkill.contains(chosenTypeSkill.toLowerCase());
      final matchesLokasi =
          chosenLokasi == null || lokasi.contains(chosenLokasi.toLowerCase());

      return matchesQuery &&
          matchesTypeMagang &&
          matchesTypeSkill &&
          matchesLokasi;
    }).toList();

    setState(() {
      _filteredTawaran = Future.value(filteredTawaran);
      jobCount = filteredTawaran.length; // Update jobCount with filtered count
    });

    late List<Mahasiswa> choosenMhs = [];

    final response_mhs = await http.get(
      Uri.parse(
          'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
    );
    if (response_mhs.statusCode == 200 && widget.studentId != "null") {
      final Map<String, dynamic> datamhs = json.decode(response_mhs.body);
      Mahasiswa? selectedMahasiswa;

      datamhs.forEach((key, value) {
        final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
        if (mahasiswa.nrp == widget.studentId) {
          selectedMahasiswa = mahasiswa;
        }
      });

      if (selectedMahasiswa != null) {
        setState(() {
          choosenMhs.add(selectedMahasiswa!);
        });
      }
      List<String> _filteredTawaranID = [];
      List<TawaranProject> filteredTawaranProjects = [];

      if (choosenMhs.isNotEmpty) {
        final Map<String, dynamic> applications = choosenMhs[0].tawaranPilihan;

        applications.forEach((key, value) {
          try {
            TawaranProject project = value;
            filteredTawaranProjects.add(project);
            _filteredTawaranID.add(project.idTawaran);
          } catch (e) {
            print('Error parsing TawaranProject from JSON: $e');
            // Handle parsing error (e.g., log it, skip this project, etc.)
          }

          List<Map<String, dynamic>> filteredTawaran = [];
          _filteredTawaran.then((tawaranList) {
            filteredTawaran = tawaranList
                .where(
                    (tawaran) => !_filteredTawaranID.contains(tawaran['key']))
                .toList();
            setState(() {
              _filteredTawaran = Future.value(filteredTawaran);
              jobCount = filteredTawaran.length;
            });
          });
        });
      }
      ;
    }
    ;

    return filteredTawaran;
  }

  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTawaran = _filterTawaran(query);
    });
  }

  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     setState(() {
  //       jobCount = data.length;
  //     });
  //     return data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double threshold = 600.0;
    return Column(
      children: [
        SizedBox(height: 16),
        const Center(
          child: AutoSizeText(
            'Lamaran LEAP',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            minFontSize: 12.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 50.0, // Set a fixed height for the container
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(8.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                  ),
                ),
                Container(
                  height: 50.0, // Set the same height for the button
                  child: ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(8.0)),
                      ),
                    ),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih skill",
                    chosenValue: chosenTypeSkill,
                    itemsList: TypeSkillList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih skill';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        chosenTypeSkill = value;
                        _performSearch(); // Trigger search on dropdown change
                      });
                    }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih magang",
                    chosenValue: chosenTypeMagang,
                    itemsList: TypeMagangList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih magang';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        chosenTypeMagang = value;
                        _performSearch(); // Trigger search on dropdown change
                      });
                    }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      chosenLokasi = value;
                      _performSearch(); // Trigger search on text change
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    hintText: 'Lokasi',
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${jobCount > 0 ? jobCount : 0} job${jobCount != 1 ? 's' : ''} found:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: ResponsiveGrid(fetchData: _filteredTawaran))
            ],
          ),
        ),
      ],
    );
  }
}
