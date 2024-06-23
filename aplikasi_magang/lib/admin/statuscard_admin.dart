import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusCardAdmin extends StatefulWidget {
  final String nrp;
  final String id_tawaran;
  final int status_tawaran;

  StatusCardAdmin({
    required this.nrp,
    required this.id_tawaran,
    required this.status_tawaran,
    Key? key,
  }) : super(key: key);

  @override
  _StatusCardAdminState createState() => _StatusCardAdminState();
}

class _StatusCardAdminState extends State<StatusCardAdmin> {
  late String namaProject;
  late String asalPerusahaan;
  late int dropdownValue;

  @override
  void initState() {
    super.initState();
    // Fetch data from Firebase
    fetchData();
    // Set dropdown value based on status_tawaran
    dropdownValue = widget.status_tawaran;
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey(widget.id_tawaran)) {
          final tawaran = data[widget.id_tawaran];
          setState(() {
            namaProject = tawaran['nama_project'];
            asalPerusahaan = tawaran['asal_perusahaan'];
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        width: 300,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$namaProject',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '$asalPerusahaan',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Status Lamaran:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<int>(
                      value: dropdownValue,
                      onChanged: (int? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                        // Handle status change if needed
                        print('Selected status: $dropdownValue');
                      },
                      items: [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text('Applied'),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Interview Process'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Accepted'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('Rejected'),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text('Canceled'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
