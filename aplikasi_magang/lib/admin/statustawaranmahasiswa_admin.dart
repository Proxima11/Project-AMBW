import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aplikasi_magang/admin/tawaranModel.dart';

class StatusTawaranMahasiswaAdmin extends StatefulWidget {
  final String nrp;
  final String idTawaran;
  final int statusTawaran;

  const StatusTawaranMahasiswaAdmin({
    required this.nrp,
    required this.idTawaran,
    required this.statusTawaran,
    super.key,
  });

  @override
  _StatusTawaranMahasiswaAdminState createState() => _StatusTawaranMahasiswaAdminState();
}

class _StatusTawaranMahasiswaAdminState extends State<StatusTawaranMahasiswaAdmin> {
  String namaPerusahaan = '';
  String namaProject = '';
  String dropdownValue = 'Unknown';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  // Future<void> fetchData() async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref().child('dataTawaran/${widget.idTawaran}');
  //   DatabaseEvent event = await ref.once();

  //   if (event.snapshot.exists) {
  //     Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);

  //     setState(() {
  //       namaPerusahaan = data['namaPerusahaan'] ?? 'Unknown';
  //       namaProject = data['namaProject'] ?? 'Unknown';
  //       dropdownValue = getStatusText(widget.statusTawaran);
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Applied';
      case 1:
        return 'Interviewed';
      case 2:
        return 'Approved';
      case 3:
        return 'Rejected';
      case 4:
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }

  void onStatusChanged(String newValue) {
    setState(() {
      dropdownValue = newValue;
    });
    // Update the status in the database or handle it as needed
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        width: 400,
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(widget.idTawaran, style: TextStyle(fontSize: 15, color: Colors.black)),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(namaPerusahaan, style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(namaProject, style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            onStatusChanged(newValue);
                          }
                        },
                        items: <String>[
                          'Applied',
                          'Interviewed',
                          'Approved',
                          'Rejected',
                          'Canceled',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
