import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../mahasiswa/detail_pengumuman.dart';

class ResponsiveGridPengumuman extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> fetchData;

  ResponsiveGridPengumuman({required this.fetchData});

  @override
  Widget build(BuildContext context) {
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

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4.5 / 2,
                ),
                itemBuilder: (context, index) {
                  return GridItem(data: snapshot.data![index]);
                },
                itemCount: data.length,
                padding: EdgeInsets.all(10),
              );
            }
          },
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final Map<String, dynamic> data;

  GridItem({required this.data});


  @override
  Widget build(BuildContext context) {
    // log(data['value']['title']);
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
              data['value']['judul'] ?? 'No Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              data['value']['tanggal'] ?? 'No Date',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            detailPengumuman(fetchData: data)), // Assuming DetailPengumuman is defined
                  );
                },
                child: Text('Lihat Pengumuman'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
