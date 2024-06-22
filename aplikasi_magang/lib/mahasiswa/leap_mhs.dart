import 'package:flutter/material.dart';
import 'detail_selected_magang.dart';

class leap_mhs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('LEAP'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            AktifTable(),
            SelesaiTable(),
          ],
        ),
      ),
    );
  }
}

class AktifTable extends StatelessWidget {
  List<DataRow> rows = [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        'no': 1,
        'nama': 'John Doe',
        'nrp': '12345',
        'judul': 'Proyek A',
        'pembimbing':
            'Prof. Xxxxxxxxxxxzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz',
        'mentor':
            'Yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
        'mitra': 'Z',
        'periode': '2023',
        'tipe': 'Aktif',
        'aksi': 'Aksi 1'
      },
      {
        'no': 2,
        'nama': 'Jane Smith',
        'nrp': '67890',
        'judul': 'Proyek B',
        'pembimbing': 'Prof. Y',
        'mentor': 'Z',
        'mitra': 'X',
        'periode': '2023',
        'tipe': 'Aktif'
      },
      // Tambahkan lebih banyak data sesuai kebutuhan
    ];

    // Membuat list of DataRow dari data
    List<DataRow> rows = data.map((item) {
      return DataRow(
        cells: [
          DataCell(Container(width: 100, child: Text('#${item['no']}'))),
          DataCell(
            Container(
              width: 100,
              child: Text(
                item['nama'],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(Container(
            width: 100,
            child: Text(
              item['nrp'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['judul'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['pembimbing'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['mentor'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['mitra'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['periode'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: Text(
              item['tipe'],
              overflow: TextOverflow.ellipsis,
            ),
          )),
          DataCell(Container(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => detail_selected_magang()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Rectangle shape
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Icon(Icons.search, color: Colors.white),
            ),
          )),
        ],
      );
    }).toList();

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
                        label: Text('Judul',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Nama Pembimbing',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mentor',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
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

class SelesaiTable extends StatelessWidget {
  List<DataRow> rows = [];

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
            DataCell(Text('-')),
          ],
        ),
      );
    }
    return LayoutBuilder(builder: (context, constraints) {
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
                        label: Text('Judul',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Nama Pembimbing',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mentor',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Aksi',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: rows, // No data available
                ),
              )),
        ),
      );
    });
  }
}
