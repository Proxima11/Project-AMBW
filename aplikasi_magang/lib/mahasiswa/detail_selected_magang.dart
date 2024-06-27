import 'package:aplikasi_magang/mahasiswa/mahasiswa_operation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class detail_selected_magang extends StatefulWidget {
  final String idTawaran;
  final String studentId;
  final String judul;
  final String nama_mahasiswa;
  final String nama_mitra;
  final String nama_pembimbing;
  final String nama_mentor;
  detail_selected_magang(
      {required this.idTawaran,
      required this.studentId,
      required this.judul,
      required this.nama_mahasiswa,
      required this.nama_pembimbing,
      required this.nama_mentor,
      required this.nama_mitra});
  @override
  State<detail_selected_magang> createState() => _detail_selected_magangState();
}

class _detail_selected_magangState extends State<detail_selected_magang> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text((widget.judul != null || widget.judul != 'null'
              ? widget.judul
              : '')),
          bottom: TabBar(
            tabs: [
              Tab(text: "Laporan & Proposal LEAP"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LamaranTab(
              idTawaran: widget.idTawaran.toString(),
              studentId: widget.studentId.toString(),
              nama_mahasiswa: widget.nama_mahasiswa.toString(),
              nama_pembimbing: widget.nama_pembimbing.toString(),
              nama_mentor: widget.nama_mentor.toString(),
              nama_mitra: widget.nama_mitra.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class LamaranTab extends StatefulWidget {
  final String idTawaran;
  final String studentId;
  final String nama_mahasiswa;
  final String nama_mitra;
  final String nama_pembimbing;
  final String nama_mentor;
  LamaranTab(
      {required this.idTawaran,
      required this.studentId,
      required this.nama_mahasiswa,
      required this.nama_pembimbing,
      required this.nama_mentor,
      required this.nama_mitra});
  @override
  State<LamaranTab> createState() => _LamaranTabState();
}

class _LamaranTabState extends State<LamaranTab> {
  TextEditingController cvLinkController_proposal = TextEditingController();
  TextEditingController cvLinkController_kemajuan = TextEditingController();
  TextEditingController cvLinkController_akhir = TextEditingController();
  late DatabaseReference dbRef;
  late List<Mahasiswa> choosenMhs = [];

  bool isValidURL(String url) {
    Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isAbsolute || uri.hasScheme);
  }

  void submitproposal() async {
    String cvLink = cvLinkController_proposal.text;
    if (!isValidURL(cvLink)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }

    if (cvLink.isNotEmpty && choosenMhs.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
        );

        String? _key;

        if (response.statusCode == 200 && widget.studentId != "null") {
          final Map<String, dynamic> data = json.decode(response.body);
          Mahasiswa? selectedMahasiswa;
          data.forEach((key, value) {
            final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
            if (mahasiswa.nrp == widget.studentId) {
              choosenMhs.add(mahasiswa);
              _key = key;
            }
          });
        }
        ;

        DateTime now = DateTime.now();
        String formattedDate = DateFormat('d/M/yyyy').format(now);
        String? id_taw;

        dbRef = FirebaseDatabase.instance
            .ref()
            .child('dataMahasiswa')
            .child(_key!)
            .child('tawaranPilihan')
            .child(widget.idTawaran)
            .child('laporan');

        await dbRef.set({
          'jenis_laporan': "Laporan Proposal",
          'status_laporan': 0,
          'laporanLink': cvLink, // Set the tanggal with the current date
          'tanggal_update': formattedDate, // Example timestamp
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Laporan berhasil diajukan')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan laporan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Laporan',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      constraints.maxWidth > 800
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Nama Mahasiswa\n' +
                                        (widget.nama_mahasiswa != null ||
                                                widget.nama_mahasiswa != 'null'
                                            ? widget.nama_mahasiswa
                                            : ''),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'NRP\n' +
                                        (widget.studentId != null ||
                                                widget.studentId != 'null'
                                            ? widget.studentId
                                            : ''),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Mitra\n' +
                                        (widget.nama_mitra != null ||
                                                widget.nama_mitra != 'null'
                                            ? widget.nama_mitra
                                            : ''),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Nama Dosen\n' +
                                        (widget.nama_pembimbing != null ||
                                                widget.nama_pembimbing != 'null'
                                            ? widget.nama_pembimbing
                                            : ''),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Nama Mentor\n' +
                                        (widget.nama_mentor != null ||
                                                widget.nama_mentor != 'null'
                                            ? widget.nama_mentor
                                            : ''),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nama\n' +
                                      (widget.nama_mahasiswa != null ||
                                              widget.nama_mahasiswa != 'null'
                                          ? widget.nama_mahasiswa
                                          : ''),
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'NRP\n' +
                                      (widget.studentId != null ||
                                              widget.studentId != 'null'
                                          ? widget.studentId
                                          : ''),
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Mitra\n' +
                                      (widget.nama_mitra != null ||
                                              widget.nama_mitra != 'null'
                                          ? widget.nama_mitra
                                          : ''),
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Nama Dosen\n' +
                                      (widget.nama_pembimbing != null ||
                                              widget.nama_pembimbing != 'null'
                                          ? widget.nama_pembimbing
                                          : ''),
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Nama Mentor\n' +
                                      (widget.nama_mentor != null ||
                                              widget.nama_mentor != 'null'
                                          ? widget.nama_mentor
                                          : ''),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                      SizedBox(height: 20),
                      constraints.maxWidth > 800
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text(
                                            'Ajukan Laporan Proposal Leap'),
                                        content: SingleChildScrollView(
                                          child: Container(
                                            child: Wrap(children: [
                                              Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        cvLinkController_proposal,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      hintText: 'Link CV',
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              submitproposal();
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text('Upload Laporan Proposal Leap'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Upload Laporan Kemajuan'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Upload Laporan Akhir'),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Proposal Leap'),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Kemajuan'),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Akhir'),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 20),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Tipe'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Laporan'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Terakhir Update'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Approve Dosen'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Approve Mitra'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Aksi'),
                              ),
                            ],
                          ),
                          // Add more TableRow widgets here for each row of the table
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
