import 'tawaranModel.dart';

class Mahasiswa {
  final int indexPrestasi;
  final String nrp;
  final dynamic status;
  final Map<String, dynamic> tawaranPilihan;
  final String username;

  Mahasiswa({
    required this.indexPrestasi,
    required this.nrp,
    required this.status,
    required this.tawaranPilihan,
    required this.username,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> tawaranPilihan = {};
    if (json['tawaranPilihan'] != null) {
      json['tawaranPilihan'].forEach((key, value) {
        tawaranPilihan[key] = TawaranProject.fromJson(value);
      });
    }

    return Mahasiswa(
      indexPrestasi: json['indexPrestasi'] ?? 0,
      nrp: json['nrp'] ?? '',
      status: json['status'],
      tawaranPilihan: tawaranPilihan,
      username: json['username'] ?? '',
    );
  }
}