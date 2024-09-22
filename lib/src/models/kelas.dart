class Kelas {
  Kelas({
    this.id,
    this.kelas,
  });

  String? id;
  String? kelas;

  factory Kelas.fromJson(Map<String, dynamic> json) => Kelas(
        id: json["id"],
        kelas: json["kelas"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kelas": kelas,
      };

  static List<Kelas> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Kelas.fromJson(item)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Kelas> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
