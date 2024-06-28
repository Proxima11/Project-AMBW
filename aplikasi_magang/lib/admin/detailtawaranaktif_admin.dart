import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailTawaranAktifAdmin extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailTawaranAktifAdmin({required this.item});

  @override
  _DetailTawaranAktifAdminState createState() => _DetailTawaranAktifAdminState();
}

class _DetailTawaranAktifAdminState extends State<DetailTawaranAktifAdmin> {
  late Map<String, dynamic> _item;
  List<Map<String, dynamic>> _relatedMahasiswa = [];

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _fetchRelatedMahasiswa();
  }

  Future<void> _fetchRelatedMahasiswa() async {
    final url = Uri.https(
      'ambw-leap-default-rtdb.firebaseio.com',
      'dataMahasiswa.json',
    );

    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);

      List<Map<String, dynamic>> relatedMahasiswa = [];

      data.forEach((key, value) {
        if (value['tawaranPilihan'] != null) {
          value['tawaranPilihan'].forEach((tawaranKey, tawaranValue) {
            if (tawaranValue['id_tawaran'] == _item['id_tawaran']) {
              relatedMahasiswa.add({
                'nrp': value['nrp'],
                'status': value['status'],
                'tawaran': tawaranValue,
                'username': value['username'],
              });
            }
          });
        }
      });

      setState(() {
        _relatedMahasiswa = relatedMahasiswa;
      });
    } catch (e) {
      print('Error fetching related data: $e');
    }
  }

  Future<void> _updateStatusApproval() async {
    final String id = _item['id'];
    final String apiUrl =
        'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran/$id.json';

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'status_approval': 2,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _item['status_approval'] = 2; // Update the local item state
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tawaran telah ditutup'),
          ),
        );

        // Navigate back to HomeTabAdmin and refresh data
        Navigator.of(context).pop(true); // Pop the DetailScreen from the navigation stack
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Tawaran gagal ditutup: ${response.reasonPhrase}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tawaran gagal ditutup: $e'),
        ),
      );
    }
  }

  String _getStatus(Map<String, dynamic> tawaran){
    print(tawaran['status_tawaran']);
    String statusMahasiswa = '';
    int status = tawaran['status_tawaran'];


      if (status == 0) {
        statusMahasiswa = 'Mendaftar';
      } else if (status == 1) {
        statusMahasiswa = 'Proses Wawancara';
      } else if (status == 2) {
        statusMahasiswa = 'Diterima';
      } else if (status == 3) {
        statusMahasiswa = 'Ditolak';
      } else if (status == 4) {
        statusMahasiswa = 'Dibatalkan';
      }

    return statusMahasiswa;
  }

  @override
  Widget build(BuildContext context) {
    final ipkFormatted = _item['min_ipk'].toStringAsFixed(2);
    
    print("update");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Tawaran",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text(_item['nama_project'], style: TextStyle(fontSize: 18),)),
                SizedBox(height: 20.0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mitra : ${_item['asal_perusahaan']}'),
                              SizedBox(height: 8,),
                              Text('Min IPK : $ipkFormatted'),
                              SizedBox(height: 8,),
                              Text('Tanggal Mulai Pendaftaran : ${_item['tanggal_mulai_rekrut']}'),
                              SizedBox(height: 8,),
                              Text('Tanggal Akhir Pendaftaran : ${_item['tanggal_akhir_rekrut']}'),
                              SizedBox(height: 8,),
                              Text('Kuota: ${_item['kuota_terima']} orang'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jenis Tawaran : ${_item['jenis']}'),
                              SizedBox(height: 8,),
                              Text('Skill : ${_item['skill']}'),
                              SizedBox(height: 8,),
                              Text('Tanggal Pelaksanaan : ${_item['tanggal_pelaksanaan']}'),
                              SizedBox(height: 8,),
                              Text('Periode Pelaksanaan: ${_item['periode']}'),
                              SizedBox(height: 8,),
                              Text('Lokasi Pelaksanaan: ${_item['lokasi']}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${_item['deskripsi']}'),
                ),
                SizedBox(height: 20),
                Text(
                  'Mahasiswa Terkait:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _relatedMahasiswa.length,
                    itemBuilder: (context, index) {
                    
            
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          width: double.infinity,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(_relatedMahasiswa[index]['username']),
                                    Text(_relatedMahasiswa[index]['nrp'])
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Status Mahasiswa :'),
                                    Text(_getStatus(_relatedMahasiswa[index]['tawaran'])),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateStatusApproval,
                  child: Text('Tutup Tawaran'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
