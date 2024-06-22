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
                  color: Colors.blue,
                  child: Align(
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
                        color: Colors.yellow,
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
                                  Text(nama, style: TextStyle(fontSize: 16),),
                                  Text(nrp, style: TextStyle(fontSize: 12),),
                                ],
                              ),
                            ),
                            Text("index : "+indexScore),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(alignment: Alignment.center,child: Text("Button")),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     width: 180,
    //     height: 200,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(5),
    //       boxShadow: const [
    //         BoxShadow(
    //           color: Colors.grey,
    //           offset: Offset(1.0, 1.0),
    //           blurRadius: 10.0,
    //           spreadRadius: 0.1,
    //         ),
    //       ],
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(
    //           flex: 3,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               image: DecorationImage(
    //                 image: AssetImage(profilePicture),
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 5, bottom: 5),
    //                 child: Text(
    //                   nama,
    //                   style: const TextStyle(
    //                     fontWeight: FontWeight.w700,
    //                     fontSize: 15,
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 5, bottom: 5),
    //                 child: Text(
    //                   nrp,
    //                   style: const TextStyle(
    //                     fontWeight: FontWeight.w700,
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 5, bottom: 5),
    //                 child: Text(
    //                   indexScore,
    //                   style: const TextStyle(
    //                     fontWeight: FontWeight.w700,
    //                     fontSize: 12,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}