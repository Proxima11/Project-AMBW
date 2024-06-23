import 'package:aplikasi_magang/admin/details/detailmahasiswa_admin.dart';
import 'package:aplikasi_magang/admin/models/mahasiswaModel.dart';
import 'package:flutter/material.dart';

class MahasiswaCard extends StatelessWidget {
  final Mahasiswa dataMahasiswa;
  String ipk = '';

  MahasiswaCard({
    required this.dataMahasiswa,
    super.key,
  }) {
    createIpk();
  }

  void createIpk(){
    double ipkNum = dataMahasiswa.indexPrestasi / 100;
    ipk = ipkNum.toStringAsFixed(2);
  }

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
              const Expanded(
                flex: 1,
                child: SizedBox(
                  height: 150,
                  width: 300,
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
                                Text(dataMahasiswa.username, style: const TextStyle(fontSize: 16),),
                                Text(dataMahasiswa.nrp, style: const TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text("index : $ipk"),
                          ),
                        ],
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
                                  dataMahasiswa: dataMahasiswa,
                                  ipk: ipk,
                                ),
                              ),
                            );
                            
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