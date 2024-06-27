import '../login.dart';
import 'package:flutter/material.dart';
import 'listjob.dart';
import 'applicant_homepage.dart';
import 'form_addnewjob.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homelistjob.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomepageEmployer extends StatelessWidget {
  final String data;
  HomepageEmployer({required this.data, super.key});

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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.account_circle), // Profile icon
                const SizedBox(width: 8),
                Text(
                  'Welcome, $data',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ), // Student name
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
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
              Tab(text: 'Pelamar'),
              Tab(
                text: 'Upload Open Pekerjaan Baru',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Homelistjob(data: data),
            ApplicantHomepage(data: data),
            FormAddNewJob(data: data)
          ],
        ),
      ),
    );
  }
}
