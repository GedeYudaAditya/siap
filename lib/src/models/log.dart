class Log {
  // "id_laporan": "25",
  //           "id_log": "107",
  //           "status": "Start",
  //           "keterangan": "test",
  //           "id_pelapor": "ID000039",
  //           "pelapor": "Ida Bagus Anom Mudita",
  //           "date_time_selesai": "2023-09-19 08:18:40",
  //           "date_time_mulai": "2023-09-19 08:18:40"
  Log({
    required this.id,
    required this.idLaporan,
    required this.status,
    required this.keterangan,
    required this.idPelapor,
    required this.pelapor,
    required this.dateTimeSelesai,
    required this.dateTimeMulai,
  });

  String id;
  String idLaporan;
  String status;
  String keterangan;
  String idPelapor;
  String pelapor;
  String dateTimeSelesai;
  String dateTimeMulai;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id_log"],
        idLaporan: json["id_laporan"],
        status: json["status"],
        keterangan: json["keterangan"],
        idPelapor: json["id_pelapor"],
        pelapor: json["pelapor"],
        dateTimeSelesai: json["date_time_selesai"],
        dateTimeMulai: json["date_time_mulai"],
      );

  Map<String, dynamic> toJson() => {
        "id_log": id,
        "id_laporan": idLaporan,
        "status": status,
        "keterangan": keterangan,
        "id_pelapor": idPelapor,
        "pelapor": pelapor,
        "date_time_selesai": dateTimeSelesai,
        "date_time_mulai": dateTimeMulai,
      };

  static List<Log> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Log.fromJson(item)).toList();
  }
}
