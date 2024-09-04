class Status {
  int id;
  String status;

  Status({required this.id, required this.status});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: int.parse(json["id"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };

  static List<Status> fromJsonList(List list) {
    if (list.isEmpty) return [];
    return list.map((item) => Status.fromJson(item)).toList();
  }

  static int getStatusId({required String status, required List<Status> data}) {
    print(data.indexWhere((element) => element.status == status));
    return data[data.indexWhere((element) => element.status == status)].id;
  }
}
