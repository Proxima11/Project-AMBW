class TawaranProject {
  final String idTawaran;
  final int statusTawaran;

  TawaranProject({
    required this.idTawaran,
    required this.statusTawaran,
  });

  factory TawaranProject.fromJson(Map<String, dynamic> json) {
    return TawaranProject(
      idTawaran: json['id_tawaran'] ?? '',
      statusTawaran: json['status_tawaran'] ?? 0,
    );
  }
}