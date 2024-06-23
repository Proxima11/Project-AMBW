import 'package:aplikasi_magang/mahasiswa/detail_lamaran.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';

class ResponsiveGrid extends StatelessWidget {
  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://ambw-leap-default-rtdb.firebaseio.com/dataTawaran.json'));

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     return data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  final Future<List<Map<String, dynamic>>> fetchData;

  ResponsiveGrid({required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              if (constraints.maxWidth < 900) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 1300) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 3;
              }

              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 2,
                      ),
                      itemBuilder: (context, index) {
                        return GridItem(data: snapshot.data![index]);
                      },
                      itemCount: snapshot.data!.length,
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final Map<String, dynamic> data;

  GridItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (data['value']['nama_project']?.toString() == 'null' || data['value']['nama_project'] == null
                  ? ' '
                  : data['value']['nama_project'].toString()),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Mitra : ' + (data['value']['asal_perusahaan']?.toString() == 'null' || data['value']['asal_perusahaan'] == null
                  ? ' '
                  : data['value']['asal_perusahaan'].toString())
                  ,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'LEAP : ' + (data['value']['jenis']?.toString() == 'null' || data['value']['jenis'] == null
                  ? ' '
                  : data['value']['jenis'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Pendaftaran : ' + (data['value']['tanggal_mulai_rekrut']?.toString() == 'null' || data['value']['tanggal_mulai_rekrut'] == null
                  ? ' '
                  : data['value']['tanggal_mulai_rekrut'].toString()) + ' s/d ' +(data['value']['tanggal_akhir_rekrut']?.toString() == 'null' || data['value']['tanggal_akhir_rekrut'] == null
                  ? ' '
                  : data['value']['tanggal_akhir_rekrut'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Pelaksanaan : ' + (data['value']['tanggal_pelaksanaan']?.toString() == 'null' || data['value']['tanggal_pelaksanaan'] == null
                  ? ' '
                  : data['value']['tanggal_pelaksanaan'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Lokasi : ' + (data['value']['lokasi']?.toString() == 'null' || data['value']['lokasi'] == null
                  ? ' '
                  : data['value']['lokasi'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Kuota : ' + (data['value']['kuota']?.toString() == 'null' || data['value']['kuota'] == null
                  ? ' '
                  : data['value']['kuota'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Skill : ' + (data['value']['skill']?.toString() == 'null' || data['value']['skill'] == null
                  ? ' '
                  : data['value']['skill'].toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => detail_lamaran(fetchData: data)),
                  );
                },
                child: Text('Lihat Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
