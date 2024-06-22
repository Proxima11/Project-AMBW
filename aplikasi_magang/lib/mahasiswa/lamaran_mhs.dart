import 'package:flutter/material.dart';

class lamaran_mhs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lamaran'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Waiting'),
              Tab(text: 'Interview'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LamaranTable(),
            InterviewTable(),
            ApprovedTable(),
            RejectedTable(),
            CancelledTable()
          ],
        ),
      ),
    );
  }
}

class LamaranTable extends StatelessWidget {
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
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Tawaran')),
            DataColumn(label: Text('Tipe')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}

class InterviewTable extends StatelessWidget {
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
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Tawaran')),
            DataColumn(label: Text('Tipe')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}

class ApprovedTable extends StatelessWidget {
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
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Tawaran')),
            DataColumn(label: Text('Tipe')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}

class RejectedTable extends StatelessWidget {
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
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Tawaran')),
            DataColumn(label: Text('Tipe')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}

class CancelledTable extends StatelessWidget {
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
            DataColumn(label: Text('Mitra')),
            DataColumn(label: Text('Tawaran')),
            DataColumn(label: Text('Tipe')),
          ],
          rows: [], // No data available
        ),
      ),
    );
  }
}
