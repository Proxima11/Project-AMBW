class Mahasiswa {
  final int indexPrestasi;
  final String nrp;
  final dynamic status;
  Map<String, dynamic> tawaranPilihan;
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

class TawaranProject {
  final String idTawaran;
  final int statusTawaran;
  final String tanggalUpdate;
  final String namaPembimbing;
  final String namaMentor;

  TawaranProject({
    required this.idTawaran,
    required this.statusTawaran,
    required this.tanggalUpdate,
    required this.namaPembimbing,
    required this.namaMentor,
  });

  factory TawaranProject.fromJson(Map<String, dynamic> json) {
    return TawaranProject(
        idTawaran: json['id_tawaran'] ?? '',
        statusTawaran: json['status_tawaran'] ?? 0,
        tanggalUpdate: json['tanggal_update'] ?? '',
        namaPembimbing: json['nama_pembimbing'] ?? '',
        namaMentor: json['nama_mentor'] ?? '');
  }
}
