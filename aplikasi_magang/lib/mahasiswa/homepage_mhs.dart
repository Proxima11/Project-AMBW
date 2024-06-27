import 'package:aplikasi_magang/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'homeTab_mhs.dart';
import 'lamaran_mhs.dart';
import 'pengumuman_mhs.dart';
import 'leap_mhs.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  // final String data;
  // HomePage({required this.data, super.key});

  // final theUser = FirebaseAuth.instance.currentUser!;

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
                    'Welcome, ',
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
            HomeTab(),
            lamaran_mhs(studentId: "C14210001"),
            leap_mhs(studentId: "C14210001"),
            pengumuman_mhs(),
          ],
        ),
      ),
    );
  }
}
