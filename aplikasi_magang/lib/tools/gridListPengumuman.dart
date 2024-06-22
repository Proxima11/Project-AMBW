import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../mahasiswa/detail_pengumuman.dart';

class ResponsiveGridPengumuman extends StatelessWidget {
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

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4.5 / 2,
                ),
                itemBuilder: (context, index) {
                  return GridItem();
                },
                itemCount: 10, // Number of items
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text('Description goes here.'),
              Spacer(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => detailPengumuman()),
                      );
                    },
                    child: Text('Lihat Pengumuman'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
