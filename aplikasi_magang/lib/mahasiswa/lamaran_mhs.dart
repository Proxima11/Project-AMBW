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
          physics: NeverScrollableScrollPhysics(),
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
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

class InterviewTable extends StatelessWidget {
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
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

class ApprovedTable extends StatelessWidget {
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
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

class RejectedTable extends StatelessWidget {
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
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

class CancelledTable extends StatelessWidget {
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
                        label: Text('Mitra',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tawaran',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tipe',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Periode',
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
