import 'package:flutter/material.dart';
import 'listjob.dart';
import 'applicant_homepage.dart';
import 'form_addnewjob.dart';

class HomepageEmployer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.account_circle), // Profile icon
                SizedBox(width: 8),
                Text(
                  'Welcome, Employeer',
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
              Tab(text: 'Pelamar'),
              Tab(
                text: 'Upload Open Pekerjaan Baru',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [Listjob(), ApplicantHomepage(), FormAddnewjob()],
        ),
      ),
    );
  }
}
