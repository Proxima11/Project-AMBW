import 'package:flutter/material.dart';

class detail_selected_magang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "Lamaran Aplikasi Pusat Layanan Terpadu (Front-End & Back-End)"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Laporan & Proposal LEAP"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LamaranTab(),
          ],
        ),
      ),
    );
  }
}

class LamaranTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Laporan',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      constraints.maxWidth > 800
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Nama\nKRISTOFER STEVEN',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'NRP\nC14210139',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Mitra\nPT. Cross Network Indonesia',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Nama Dosen\nDr. John Doe',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Nama\nKRISTOFER STEVEN',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'NRP\nC14210139',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Mitra\nPT. Cross Network Indonesia',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Nama Dosen\nDr. John Doe',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                      SizedBox(height: 20),
                      constraints.maxWidth > 800
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Upload Laporan Proposal Leap'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Upload Laporan Kemajuan'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Upload Laporan Akhir'),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Proposal Leap'),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Kemajuan'),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Upload Laporan Akhir'),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 20),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Tipe'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Laporan'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Terakhir Update'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Approve Dosen'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Approve Mitra'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Aksi'),
                              ),
                            ],
                          ),
                          // Add more TableRow widgets here for each row of the table
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
