import 'package:aplikasi_magang/admin/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'detailmahasiswa_admin.dart';

class MahasiswaTabAdmin extends StatelessWidget {
  const MahasiswaTabAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        bottom: const TabBar(
            tabs: [
              Tab(text: 'Data Mahasiswa'),
              Tab(text: 'Buat Akun'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DetailMahasiswaAdmin(),
            RegisterPage(),
          ],
        ),
      ),
    );
  }
}