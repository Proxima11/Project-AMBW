// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // Define the Mahasiswa and TawaranProject classes
// class Mahasiswa {
//   final String nrp;
//   final Map<String, TawaranProject> tawaranPilihan;

//   Mahasiswa({
//     required this.nrp,
//     required this.tawaranPilihan,
//   });

//   factory Mahasiswa.fromJson(Map<String, dynamic> json) {
//     // Parse tawaranPilihan from JSON
//     Map<String, dynamic> tawaranPilihanJson = json['tawaranPilihan'];
//     Map<String, TawaranProject> tawaranPilihan = {};
//     tawaranPilihanJson.forEach((key, value) {
//       tawaranPilihan[key] = TawaranProject.fromJson(value);
//     });

//     return Mahasiswa(
//       nrp: json['nrp'],
//       tawaranPilihan: tawaranPilihan,
//     );
//   }
// }

// class TawaranProject {
//   final String idTawaran;
//   final int statusTawaran;

//   TawaranProject({
//     required this.idTawaran,
//     required this.statusTawaran,
//   });

//   factory TawaranProject.fromJson(Map<String, dynamic> json) {
//     return TawaranProject(
//       idTawaran: json['id_tawaran'],
//       statusTawaran: json['status_tawaran'],
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mahasiswa List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DetailmahasiswaAdminPage(),
//     );
//   }
// }

// class DetailmahasiswaAdminPage extends StatefulWidget {
//   @override
//   _DetailmahasiswaAdminPageState createState() => _DetailmahasiswaAdminPageState();
// }

// class _DetailmahasiswaAdminPageState extends State<DetailmahasiswaAdminPage> {
//   List<Mahasiswa> mahasiswaList = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final response = await http.get(Uri.parse('https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'));
//     if (response.statusCode == 200) {
//       // If the server returns a 200 OK response, parse the JSON
//       final Map<String, dynamic> data = jsonDecode(response.body);

//       List<Mahasiswa> tempMahasiswaList = [];
//       data.forEach((key, value) {
//         tempMahasiswaList.add(Mahasiswa.fromJson(value));
//       });

//       setState(() {
//         mahasiswaList = tempMahasiswaList;
//       });
//     } else {
//       // If the server response was not OK, throw an error.
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mahasiswa List'),
//       ),
//       body: ListView.builder(
//         itemCount: mahasiswaList.length,
//         itemBuilder: (context, index) {
//           Mahasiswa mahasiswa = mahasiswaList[index];
//           return ListTile(
//             title: Text('NRP: ${mahasiswa.nrp}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Tawaran Pilihan:'),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: mahasiswa.tawaranPilihan.values.map((tawaran) {
//                     return Text('ID Tawaran: ${tawaran.idTawaran}, Status Tawaran: ${tawaran.statusTawaran}');
//                   }).toList(),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
