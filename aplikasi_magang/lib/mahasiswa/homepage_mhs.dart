import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'homeTab_mhs.dart';
import 'lamaran_mhs.dart';
import 'pengumuman_mhs.dart';
import 'leap_mhs.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatelessWidget {
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
                Icon(Icons.account_circle), // Profile icon
                SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    'Welcome, Student Name',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeTab(),
            lamaran_mhs(studentId: "C14210001"),
            leap_mhs(),
            pengumuman_mhs(),
          ],
        ),
      ),
    );
  }
}
