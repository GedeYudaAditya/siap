class Laporan {
  Laporan({
    this.id,
    this.idKlarifikasi,
    this.klarifikasi,
    this.keterangan,
    this.namaSiswa,
    this.namaPelapor,
    this.sekolah,
    this.status,
    this.dateCreated,
  });

  String? id;
  String? idKlarifikasi;
  String? klarifikasi;
  String? keterangan;
  String? namaSiswa;
  String? namaPelapor;
  String? sekolah;
  String? status;
  String? dateCreated;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        id: json["id_laporan"],
        idKlarifikasi: json["id_klasifikasi"],
        klarifikasi: json["klasifikasi"],
        keterangan: json["keterangan"],
        namaSiswa: json["nama_siswa"],
        namaPelapor: json["nama_pelapor"],
        sekolah: json["sekolah"],
        status: json['status'],
        dateCreated: json["date_created"],
      );

  Map<String, dynamic> toJson() => {
        "id_laporan": id,
        "id_klarifikasi": idKlarifikasi,
        "klarifikasi": klarifikasi,
        "keterangan": keterangan,
        "nama_siswa": namaSiswa,
        "nama_pelapor": namaPelapor,
        "sekolah": sekolah,
        "status": status,
        "date_created": dateCreated,
      };

  static List<Laporan> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Laporan.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Laporan> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
