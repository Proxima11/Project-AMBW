import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('NRP')),
            DataColumn(label: Text('Judul')),
            DataColumn(label: Text('Nama Pembimbing')),
            DataColumn(label: Text('Mentor')),
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Periode')),
            DataColumn(label: Text('Tipe')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}

class SelesaiTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('NRP')),
            DataColumn(label: Text('Judul')),
            DataColumn(label: Text('Nama Pembimbing')),
            DataColumn(label: Text('Mentor')),
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Periode')),
            DataColumn(label: Text('Tipe')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}
