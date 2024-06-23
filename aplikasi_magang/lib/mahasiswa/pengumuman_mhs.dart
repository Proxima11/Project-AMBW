import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../tools/gridListPengumuman.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class pengumuman_mhs extends StatefulWidget {
  const pengumuman_mhs({super.key});

  @override
  State<pengumuman_mhs> createState() => _pengumuman_mhsState();
}

class _pengumuman_mhsState extends State<pengumuman_mhs> {
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/pengumuman.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    void _performSearch() {
      // Implement your search logic here
      print("Searching for: ${_searchController.text}");
    }

    return Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: AutoSizeText(
            'Pengumuman',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            minFontSize: 12.0,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 50.0, // Set a fixed height for the container
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(8.0)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                  ),
                ),
                Container(
                  height: 50.0, // Set the same height for the button
                  child: ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(8.0)),
                      ),
                    ),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: ResponsiveGridPengumuman(fetchData: futureData))
            ],
          ),
        ),
      ],
    );
  }
}
