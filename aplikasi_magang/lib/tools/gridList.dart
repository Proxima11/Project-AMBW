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
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth < 900) {
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
              data['value']['nama_project'] ?? 'Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Deskripsi : ' + data['value']['deskripsi'] ??
                  'Description goes here.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Skill : ' + data['value']['skill'] ?? 'Skills',
              maxLines: 2,
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
