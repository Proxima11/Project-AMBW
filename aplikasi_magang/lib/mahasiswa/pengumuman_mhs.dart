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
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> futureData = Future.value([]);
  late Future<List<Map<String, dynamic>>> _allPengumuman = Future.value([]);
  late Future<List<Map<String, dynamic>>> _filteredPengumuman =
      Future.value([]);

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://ambw-leap-default-rtdb.firebaseio.com/pengumuman.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> allPengumuman =
          data.entries.map((e) => {'key': e.key, 'value': e.value}).toList();
      setState(() {
        _allPengumuman = Future.value(allPengumuman);
        _filteredPengumuman =
            Future.value(allPengumuman); // Initialize filtered data
      });
      return allPengumuman;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String, dynamic>>> _filterPengumuman(String query) async {
    final lowerCaseQuery = query.toLowerCase();
    final allPengumuman = await _allPengumuman;
    List<Map<String, dynamic>> filteredPengumuman =
        allPengumuman.where((pengumuman) {
      final judulPengumuman = pengumuman['value']['judul'].toLowerCase();
      return judulPengumuman.contains(lowerCaseQuery);
    }).toList();

    setState(() {
      _filteredPengumuman = Future.value(filteredPengumuman);
    });

    return filteredPengumuman;
  }

  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPengumuman = _filterPengumuman(query);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                  child:
                      ResponsiveGridPengumuman(fetchData: _filteredPengumuman))
            ],
          ),
        ),
      ],
    );
  }
}
