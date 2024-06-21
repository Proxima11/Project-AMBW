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
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 50,
            color: Colors.grey[300],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih tipe skill",
                    chosenValue: chosenTypeSkill,
                    itemsList: TypeSkillList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih tipe skill';
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
              SizedBox(width: 8),
              Expanded(
                child: CommonDropdownButton(
                    hintText: "Pilih tipe magang",
                    chosenValue: chosenTypeMagang,
                    itemsList: TypeMagangList,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih tipe magang';
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
              SizedBox(width: 8),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey[300],
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
