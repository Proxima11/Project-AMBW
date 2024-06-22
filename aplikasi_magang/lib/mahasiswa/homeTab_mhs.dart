import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import '../tools/dropdown.dart';
import '../tools/gridList.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var chosenTypeMagang;
  var chosenTypeSkill;
  var chosenLokasi;

  List<String> TypeMagangList = [
    "Industrial Experience (Magang)",
    "Community Engagement",
    "Research and Innovation"
  ];

  List<String> TypeSkillList = [
    "Business Intelligence",
    "Game Development",
    "Mobile Application (Android)",
    "Artificial Intelligence",
    "Mobile Application (IOS)",
    "Cyber Security",
    "Data Science & Analytics",
    "Enterprise Information System"
  ];

  TextEditingController _searchController = TextEditingController();
  void _performSearch() {
    // Implement your search logic here
    print("Searching for: ${_searchController.text}");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double threshold = 600.0;
    return Column(
      children: [
        SizedBox(height: 16),
        const Center(
          child: AutoSizeText(
            'Lamaran LEAP',
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih skill",
                    chosenValue: chosenTypeSkill,
                    itemsList: TypeSkillList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih skill';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        chosenTypeSkill = value;
                      });
                    }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih magang",
                    chosenValue: chosenTypeMagang,
                    itemsList: TypeMagangList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih magang';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        chosenTypeMagang = value;
                      });
                    }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Lokasi',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'xx job found :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [Expanded(child: ResponsiveGrid())],
          ),
        ),
      ],
    );
  }
}
