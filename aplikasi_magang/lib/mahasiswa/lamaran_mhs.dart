import 'package:flutter/material.dart';
import 'datatable_mhs.dart';

class lamaranMhs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lamaran', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          // TabBar(
          //   labelColor: Colors.blue,
          //   unselectedLabelColor: Colors.black,
          //   tabs: [
          //     Tab(text: 'Waiting'),
          //     Tab(text: 'Interview'),
          //     Tab(text: 'Approved'),
          //     Tab(text: 'Rejected'),
          //     Tab(text: 'Cancelled'),
          //   ],
          // ),
          Expanded(
            child: DataTableWidget(),
          ),
        ],
      ),
    );
  }
}
