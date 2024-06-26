class Tawaran {
  final String asalPerusahaan;
  final String deskripsi;
  final String idTawaran;
  final String jenis;
  final int kuotaTerima;
  final String lokasi;
  final double minIpk;
  final String namaProject;
  final String periode;
  final String skill;
  final String status;
  final int statusApproval;
  final int sudahDiterima;
  final String tanggalAkhirRekrut;
  final String tanggalMulaiRekrut;
  final String tanggalPelaksanaan;
  final String tanggalUpdateTawaran;
  final String username;
  final String waktu;

  Tawaran({
    required this.asalPerusahaan,
    required this.deskripsi,
    required this.idTawaran,
    required this.jenis,
    required this.kuotaTerima,
    required this.lokasi,
    required this.minIpk,
    required this.namaProject,
    required this.periode,
    required this.skill,
    required this.status,
    required this.statusApproval,
    required this.sudahDiterima,
    required this.tanggalAkhirRekrut,
    required this.tanggalMulaiRekrut,
    required this.tanggalPelaksanaan,
    required this.tanggalUpdateTawaran,
    required this.username,
    required this.waktu,
  });

  factory Tawaran.fromJson(Map<String, dynamic> json) {
    return Tawaran(
      asalPerusahaan: json['asal_perusahaan'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      idTawaran: json['id_tawaran'] ?? '',
      jenis: json['jenis'] ?? '',
      kuotaTerima: json['kuota_terima'] ?? 0,
      lokasi: json['lokasi'] ?? '',
      minIpk: json['min_ipk']?.toDouble() ?? 0.0,
      namaProject: json['nama_project'] ?? '',
      periode: json['periode'] ?? '',
      skill: json['skill'] ?? '',
      status: json['status'] ?? '',
      statusApproval: json['status_approval'] ?? 0,
      sudahDiterima: json['sudah_diterima'] ?? 0,
      tanggalAkhirRekrut: json['tanggal_akhir_rekrut'] ?? '',
      tanggalMulaiRekrut: json['tanggal_mulai_rekrut'] ?? '',
      tanggalPelaksanaan: json['tanggal_pelaksanaan'] ?? '',
      tanggalUpdateTawaran: json['tanggal_update_tawaran'] ?? '',
      username: json['username'] ?? '',
      waktu: json['waktu'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asal_perusahaan': asalPerusahaan,
      'deskripsi': deskripsi,
      'id_tawaran': idTawaran,
      'jenis': jenis,
      'kuota_terima': kuotaTerima,
      'lokasi': lokasi,
      'min_ipk': minIpk,
      'nama_project': namaProject,
      'periode': periode,
      'skill': skill,
      'status': status,
      'status_approval': statusApproval,
      'sudah_diterima': sudahDiterima,
      'tanggal_akhir_rekrut': tanggalAkhirRekrut,
      'tanggal_mulai_rekrut': tanggalMulaiRekrut,
      'tanggal_pelaksanaan': tanggalPelaksanaan,
      'tanggal_update_tawaran': tanggalUpdateTawaran,
      'username': username,
      'waktu': waktu,
    };
  }
}
