import 'package:flutter/material.dart';
import 'homeTab_mhs.dart';
import 'lamaran_mhs.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.account_circle), // Profile icon
                SizedBox(width: 8),
                Text(
                  'Welcome, Student Name',
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
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Lamaran'),
              Tab(text: 'LEAP'),
              Tab(text: 'Pengumuman'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            lamaranMhs(),
            Center(child: Text('Tab 3 Content')),
            Center(child: Text('Tab 4 Content')),
          ],
        ),
      ),
    );
  }
}
