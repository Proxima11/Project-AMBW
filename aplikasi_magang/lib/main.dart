import 'package:flutter/material.dart';
import 'mahasiswa/homepage_mhs.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        './mahasiswa/homepage': (context) => HomePage(),
      },
    );
  }
}
