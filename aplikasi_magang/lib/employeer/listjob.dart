import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'detail_job.dart'; // Import halaman DetailJob

class Listjob extends StatefulWidget {
  const Listjob({super.key});

  @override
  State<Listjob> createState() => _listjobstate();
}

class _listjobstate extends State<Listjob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailJob(
                        jobTitle: 'Job Title',
                        description: 'Description of the job',
                        requirements: 'Requirements for the job',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                    width: 800,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 10, // How blurry the shadow is
                          offset: Offset(0, 5), // Offset of the shadow
                        ),
                      ], // Membuat sudut tumpul
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Add padding to the left
                          child: Text(
                            'Job Title',
                            style: TextStyle(color: Colors.black, fontSize: 34),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0), // Add padding to the left
                          child: Text("Kuota"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0), // Add padding to the left
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text and button to the left
                            children: [
                              Text("Requirements"),
                              SizedBox(
                                  height:
                                      30), // Add some space between the text and the button
                              ElevatedButton(
                                onPressed: () {
                                  // Handle button press
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailJob(
                                        jobTitle: 'Job Title',
                                        description: 'Description of the job',
                                        requirements:
                                            'Requirements for the job',
                                      ),
                                    ),
                                  );
                                },
                                child: Text('See details'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Menampilkan kontainer baru yang ditambahkan
            ],
          ),
        ),
      ),
    );
  }
}
