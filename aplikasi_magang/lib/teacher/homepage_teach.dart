import 'package:aplikasi_magang/login.dart';
import 'package:aplikasi_magang/teacher/homeTab_teach.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_magang/teacher/statistic_teach.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePageTeach extends StatelessWidget {
  final String data;
  HomePageTeach({required this.data, super.key});

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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.account_circle), // Profile icon
                const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    'Welcome, $data',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    minFontSize: 12.0,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  // Logout action
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
              Tab(text: 'Statistic'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTabTeacher(),
            StatisticTeach(),
          ],
        ),
      ),
    );
  }
}
