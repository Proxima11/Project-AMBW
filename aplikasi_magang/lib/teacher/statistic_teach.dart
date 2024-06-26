import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticTeach extends StatefulWidget {
  const StatisticTeach({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatisticTeachState();
}

class StatisticTeachState extends State<StatisticTeach> {
  List<PieChartSectionData> data = [];
  int touchedIndex = -1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Future<void> fetchChartData() async {
    final url = Uri.https(
        'ambw-leap-default-rtdb.firebaseio.com', 'dataMahasiswa.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataJson = json.decode(response.body);

      int totalData = dataJson.length;
      List<List<double>> status = [
        [0],
        [0],
        [0],
        [0]
      ];

      dataJson.forEach((key, value) {
        if (value['status'] == 0) {
          status[0][0] = status[0][0] + 1;
        } else if (value['status'] == 1) {
          status[1][0] = status[1][0] + 1;
        } else if (value['status'] == 2) {
          status[2][0] = status[2][0] + 1;
        } else if (value['status'] == 3) {
          status[3][0] = status[3][0] + 1;
        }
      });

      var count = 0;
      for (var row in status) {
        debugPrint(
            "${row[0] / totalData * 100}% ${row[0]} ${totalData} ${count}");
        count += 1;
      }

      setState(() {
        isLoading = false;

        // keterima = 3
        if (status[3][0] > 0) {
          data.add(PieChartSectionData(
            color: Colors.green,
            value: status[3][0],
            title: "${format(status[3][0] / totalData * 100)}%",
          ));
        }

        // dah daftar tp ketolak semua = 2
        if (status[2][0] > 0) {
          data.add(PieChartSectionData(
            color: Colors.blue,
            value: status[2][0],
            title: "${format(status[2][0] / totalData * 100)}%",
          ));
        }

        // interview = 1
        if (status[1][0] > 0) {
          data.add(PieChartSectionData(
            color: Colors.purple,
            value: status[1][0],
            title: "${format(status[1][0] / totalData * 100)}%",
          ));
        }

        // gk daftar samsek = 0
        if (status[0][0] > 0) {
          data.add(PieChartSectionData(
            color: Colors.red,
            value: status[0][0],
            title: "${format(status[0][0] / totalData * 100)}%",
          ));
        }
      });
    } else {
      debugPrint('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Student Internship Chart',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                  return;
                                }
                                setState(() {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: showingSections(),
                          ),
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    Indicator(
                      color: Colors.green,
                      text: 'Student accepted',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Colors.blue,
                      text: 'Student without internship',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Colors.purple,
                      text: 'Student on interview period',
                      isSquare: true,
                    ),
                    Indicator(
                      color: Colors.red,
                      text: 'Student not taking an internship',
                      isSquare: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 20.0;
      final radius = isTouched ? 160.0 : 150.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: data[i].color,
        value: data[i].value,
        title: data[i].title,
        radius: radius,
        titlePositionPercentageOffset: 0.5,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
