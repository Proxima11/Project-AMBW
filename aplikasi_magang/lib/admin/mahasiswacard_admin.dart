import 'package:aplikasi_magang/admin/detailmahasiswa_admin.dart';
import 'package:flutter/material.dart';

class MahasiswaCard extends StatelessWidget {
  final String profilePicture;
  final String nama;
  final String nrp;
  final String indexScore;

  const MahasiswaCard({
    required this.profilePicture,
    required this.nama,
    required this.nrp,
    required this.indexScore,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          width: 400,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 1.0),
                blurRadius: 10.0,
                spreadRadius: 0.1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 150,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("Profile")
                  ),
                )
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nama, style: const TextStyle(fontSize: 16),),
                                  Text(nrp, style: const TextStyle(fontSize: 12),),
                                ],
                              ),
                            ),
                            Text("index : $indexScore"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailmahasiswaAdmin(
                                  profilePicture: profilePicture, nama: nama, nrp: nrp, indexScore: indexScore
                                ),
                              ),
                            );
                            //DetailmahasiswaAdmin(profilePicture: profilePicture, nama: nama, nrp: nrp, indexScore: indexScore);
                          },
                          child: const Text("Edit Status"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}