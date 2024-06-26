import 'package:aplikasi_magang/login.dart';
import 'package:aplikasi_magang/teacher/homeTab_teach.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_magang/teacher/statistic_teach.dart';

class HomePageTeach extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.account_circle), // Profile icon
                SizedBox(width: 8),
                Text(
                  'Welcome, Teacher',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ), // Student name
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  // Logout action
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
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
