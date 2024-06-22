import 'package:aplikasi_magang/admin/homepage_admin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageAdmin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
