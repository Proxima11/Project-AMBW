import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticTeach extends StatefulWidget {
  const StatisticTeach({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatisticTeachState();
}

class StatisticTeachState extends State<StatisticTeach> {
  List<PieChartSectionData> data = [
    PieChartSectionData(color: Colors.green, value: 40, title: '40%'),
    PieChartSectionData(color: Colors.blue, value: 30, title: '30%'),
    PieChartSectionData(color: Colors.purple, value: 15, title: '15%'),
    PieChartSectionData(color: Colors.red, value: 15, title: '15%'),
  ];

  int touchedIndex = -1;

  void updateChartData() {
    setState(() {
      if (touchedIndex != -1) {
        data[touchedIndex] = PieChartSectionData(
          color: data[touchedIndex].color,
          value: data[touchedIndex].value,
          title: data[touchedIndex].title,
          radius: data[touchedIndex].radius,
          titlePositionPercentageOffset:
              data[touchedIndex].titlePositionPercentageOffset,
          titleStyle: data[touchedIndex].titleStyle,
        );
      }
    });
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
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
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
                            updateChartData(); // Call function to update data
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    Indicator(
                      color: data[0].color,
                      text: 'Student accepted',
                      isSquare: true,
                    ),
                    Indicator(
                      color: data[1].color,
                      text: 'Student without internship',
                      isSquare: true,
                    ),
                    Indicator(
                      color: data[2].color,
                      text: 'Student on interview period',
                      isSquare: true,
                    ),
                    Indicator(
                      color: data[3].color,
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
