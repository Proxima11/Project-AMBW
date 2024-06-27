import 'package:aplikasi_magang/admin/penawarankonfirmasi_admin.dart';
import 'package:aplikasi_magang/admin/penawarantutup_admin.dart';
import 'package:flutter/material.dart';

class PenawaranTabAdmin extends StatelessWidget {
  const PenawaranTabAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        bottom: const TabBar(
            tabs: [
              Tab(text: 'Menunggu Konfirmasi'),
              Tab(text: 'Sudah Ditutup'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PenawarankonfirmasiAdmin(),
            PenawarantutupAdmin(),
          ],
        ),
      ),
    );
  }
}