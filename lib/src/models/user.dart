class User {
  final String id;
  final String username;
  final String nama;
  final String? email;
  final String? noTelp;
  final String? alamat;
  final String? foto;
  final String? namaSekolah;
  final int role;

  User(
      {required this.id,
      required this.username,
      required this.nama,
      this.email,
      this.noTelp,
      this.alamat,
      this.foto,
      this.namaSekolah,
      required this.role});

  // Method untuk mengonversi JSON ke model User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      nama: json['nama'],
      email: json['email'],
      noTelp: json['no_telp'],
      alamat: json['alamat'],
      foto: json['foto'],
      namaSekolah: json['nama_sekolah'],
      role: json['role'],
    );
  }

  // Method untuk mengonversi model User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nama': nama,
      'email': email,
      'no_telp': noTelp,
      'alamat': alamat,
      'foto': foto,
      'nama_sekolah': namaSekolah,
      'role': role,
    };
  }
}
