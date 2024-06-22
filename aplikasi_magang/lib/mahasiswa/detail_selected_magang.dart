import 'package:flutter/material.dart';

class detail_selected_magang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "Lamaran Aplikasi Pusat Layanan Terpadu (Front-End & Back-End)"),
          bottom: TabBar(
            tabs: [
              Tab(text: "LEAP"),
              Tab(text: "Activity"),
              Tab(text: "Bimbingan Dosen"),
              Tab(text: "Bimbingan Mitra"),
              Tab(text: "Nilai"),
              Tab(text: "Laporan & Proposal LEAP"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LamaranTab(),
            Center(child: Text("CV Content Here")),
            Center(child: Text("CV Content Here")),
            Center(child: Text("CV Content Here")),
            Center(child: Text("CV Content Here")),
            Center(child: Text("CV Content Here")),
          ],
        ),
      ),
    );
  }
}

class LamaranTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tawaran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Tanggal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Aplikasi Pusat Layanan Terpadu (Front-End & Back-End)",
                style: TextStyle(color: Colors.blue),
              ),
              Text("28-03-2024 17:05"),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mitra",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PT. Cross Network Indonesia"),
              Text("Approved"),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            "Periode",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Genap 2023"),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("KRISTOFER STEVEN"),
                  SizedBox(height: 8.0),
                  Text(
                    "NRP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("C14210139"),
                  SizedBox(height: 8.0),
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("c14210139@john.petra.ac.id"),
                  SizedBox(height: 8.0),
                  Text(
                    "Program Studi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Program Studi Informatika"),
                  SizedBox(height: 8.0),
                  Text(
                    "IPK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("3.79"),
                  SizedBox(height: 8.0),
                  Text(
                    "No. Telp",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("085102193334"),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Foto",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Image.network(
                    'https://via.placeholder.com/150',
                    width: 100,
                    height: 150,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
