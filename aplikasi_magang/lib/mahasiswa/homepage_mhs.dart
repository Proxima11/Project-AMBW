import 'package:aplikasi_magang/login.dart';
import 'package:aplikasi_magang/mahasiswa/mahasiswa_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'homeTab_mhs.dart';
import 'lamaran_mhs.dart';
import 'pengumuman_mhs.dart';
import 'leap_mhs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String data;
  HomePage({required this.data, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final theUser = FirebaseAuth.instance.currentUser!;
  late String studentId = "";
  late List<Mahasiswa> choosenMhs = [];

  void signUserOut(context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      // Handle error if sign out fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $error')),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchId();
  }

  void fetchId() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ambw-leap-default-rtdb.firebaseio.com/dataMahasiswa.json'),
      );

      if (response.statusCode == 200 && widget.data != "null") {
        final Map<String, dynamic> data = json.decode(response.body);
        Mahasiswa? selectedMahasiswa;

        data.forEach((key, value) {
          final Mahasiswa mahasiswa = Mahasiswa.fromJson(value);
          if (mahasiswa.username.toString() == widget.data) {
            selectedMahasiswa = mahasiswa;
          }
        });

        if (selectedMahasiswa != null) {
          setState(() {
            choosenMhs.add(selectedMahasiswa!);
            studentId = selectedMahasiswa!.nrp.toString();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.account_circle), // Profile icon
                const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    'Welcome, ${widget.data}',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    minFontSize: 12.0,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ), // Student name
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  // Logout action
                  signUserOut(context);
                },
                child: Expanded(
                  child: AutoSizeText(
                    'Logout',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    minFontSize: 12.0,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                style: const ButtonStyle(),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Lamaran'),
              Tab(text: 'LEAP'),
              Tab(text: 'Pengumuman'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeTab(studentId: studentId),
            lamaran_mhs(studentId: studentId),
            leap_mhs(studentId: studentId),
            pengumuman_mhs(),
          ],
        ),
      ),
    );
  }
}
