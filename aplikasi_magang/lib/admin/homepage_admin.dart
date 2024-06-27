import 'package:aplikasi_magang/admin/hometab_admin.dart';
import 'package:aplikasi_magang/admin/mahasiswatab_admin.dart';
import 'package:aplikasi_magang/admin/pengumumantab_admin.dart';
import 'package:flutter/material.dart';


class HomePageAdmin extends StatelessWidget {

  const HomePageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.account_circle), // Profile icon
                SizedBox(width: 8),
                Text(
                  'Welcome, Admin',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HomeTabAdmin(),
            const Center(child: Text('Penawaran Page')),
            //const Center(child: Text('Admin Home Page')),
            MahasiswaTabAdmin(),
            //Center(child: Text('Data Mahasiswa Page')),
            PengumumanTabAdmin(),
            //const Center(child: Text('Pengumuman Page')),
          ],
        ),
      ),
    );
  }
}
