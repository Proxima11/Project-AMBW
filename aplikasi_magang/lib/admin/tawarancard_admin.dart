import 'package:flutter/material.dart';

class TawaranCardAdmin extends StatelessWidget {
  final String namaProject;
  final String namaPerusahaan;
  final String deskripsi;
  final String skill;

  const TawaranCardAdmin({
    super.key,
    required this.namaProject,
    required this.namaPerusahaan,
    required this.deskripsi,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400, // Fixed maximum width
          ),
          child: Container(
            height: 350,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaProject,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                      ),
                      SizedBox(height: 10),
                      Text(
                        namaPerusahaan,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Deskripsi : $deskripsi",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Skill : $skill",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ()),
                        //   ),
                        // );
                        //DetailmahasiswaAdmin(profilePicture: profilePicture, nama: nama, nrp: nrp, indexScore: indexScore);
                      },
                      child: const Text("Detail Tawaran"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
