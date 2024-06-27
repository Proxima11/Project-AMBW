import 'package:flutter/material.dart';
import 'listjob.dart';
import 'applicant_homepage.dart';
import 'form_addnewjob.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'listjob_waiting_approval.dart';

class Homelistjob extends StatelessWidget {
  final String data;
  Homelistjob({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'List job approved'),
              Tab(text: 'Waiting for approved from admin'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Listjob(Username_p: data),
            ListjobWaitingApproval(data: data)
          ],
        ),
      ),
    );
  }
}
