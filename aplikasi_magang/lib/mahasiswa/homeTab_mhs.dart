import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              Expanded(child: Container(height: 50, color: Colors.grey[300])),
              SizedBox(width: 8),
              Expanded(child: Container(height: 50, color: Colors.grey[300])),
              SizedBox(width: 8),
              Expanded(child: Container(height: 50, color: Colors.grey[300])),
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
