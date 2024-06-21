import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';
import '../tools/dropdown.dart';

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
    return Column(
      children: [
        SizedBox(height: 16),
        Center(
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
            child: Text('xx job found:'),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        color: Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [
                      Wrap(children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.5, color: Colors.black),
                              bottom:
                                  BorderSide(width: 0.5, color: Colors.black),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    'https://path-to-your-icon.png', // replace with your image URL or asset path
                                    width: 50, // adjust the size as needed
                                    height: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Internship Kotlin Mobile Programmer',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'PT Angkasa Defender Indonesia - ASDF.ID',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: -1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Apply action
                                      },
                                      child: Text(
                                        'LAMAR CEPAT',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .zero, // Make the button edges square
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Chip(
                                      label: Text('REST API'),
                                    ),
                                    SizedBox(width: 8),
                                    Chip(
                                      label: Text('Kotlin'),
                                    ),
                                    SizedBox(width: 8),
                                    Chip(
                                      label: Text('Mobile App Development'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Deskripsi pekerjaan Internship Kotlin Mobile Programmer PT Angkasa Defender Indonesia - ASDF.ID',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Kami mencari banyak kandidat untuk mengisi posisi yang dibutuhkan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggung jawab :',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Membantu membuat dan mengembangkan aplikasi mobile yang dibutuhkan perusahaan\n'
                                  '• Membantu melakukan integrasi frontend & backend ke aplikasi mobile...',
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Tentang Perusahaan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'PT Angkasa Defender Indonesia - ASDF.ID, merupakan perusahaan Distributor dan IT Solution yang berfokus untuk memberikan produk dan layanan IT berkualitas untuk para perusahaan rekanan kami. Ayo gabung segera dengan mengikuti tahapan seleksinya.',
                                ),
                                SizedBox(height: 16),
                                // Add more content here if needed
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
