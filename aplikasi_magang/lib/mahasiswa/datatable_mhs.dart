import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('NRP')),
          DataColumn(label: Text('Mitra')),
          DataColumn(label: Text('Tawaran')),
          DataColumn(label: Text('Tipe')),
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Periode')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: const <DataRow>[],
      ),
    );
  }
}
