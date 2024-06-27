import 'package:aplikasi_magang/admin/RegisterPage.dart';
import 'package:aplikasi_magang/admin/assignpembimbing_admin.dart';
import 'package:aplikasi_magang/admin/hometab_admin.dart';
import 'package:aplikasi_magang/admin/mahasiswatab_admin.dart';
import 'package:aplikasi_magang/admin/penawarantab_admin.dart';
import 'package:aplikasi_magang/admin/pengumumantab_admin.dart';
import 'package:aplikasi_magang/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageAdmin extends StatelessWidget {
  final String data;
  HomePageAdmin({required this.data, super.key});

  final theUser = FirebaseAuth.instance.currentUser!;

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.account_circle), // Profile icon
                const SizedBox(width: 8),
                Text(
                  'Welcome, $data',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  signUserOut(context);
                },
                style: const ButtonStyle(),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Penawaran'),
              Tab(text: 'Mahasiswa'),
              Tab(text: 'Pengumuman'),
              Tab(text: 'Pembimbing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HomeTabAdmin(),
            const PenawaranTabAdmin(),
            const MahasiswaTabAdmin(),
            const PengumumanTabAdmin(),
            const AssignPembimbingAdmin(),
          ],
        ),
      ),
    );
  }
}
