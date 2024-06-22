import 'package:aplikasi_magang/mahasiswa/detail_lamaran.dart';
import 'package:flutter/material.dart';
import 'mahasiswa/homepage_mhs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        './mahasiswa/homepage': (context) => HomePage(),
      },
    );
  }
}
