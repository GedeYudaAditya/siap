class Siswa {
  final String idSiswa;
  final String nisn;
  final String nama;
  final String tanggalLahir;
  final String umur;
  final String jenisKelamin;
  final String sekolah;
  final String? foto;
  final String dateCreated;
  final String namaSekolah;
  final String alamatSiswa;
  final String noTeleponSiswa;
  final String kelas;
  final String idKelas;
  final String totalRundungan;

  Siswa({
    required this.idSiswa,
    required this.nisn,
    required this.nama,
    required this.tanggalLahir,
    required this.umur,
    required this.jenisKelamin,
    required this.sekolah,
    this.foto,
    required this.dateCreated,
    required this.namaSekolah,
    required this.alamatSiswa,
    required this.noTeleponSiswa,
    required this.kelas,
    required this.idKelas,
    required this.totalRundungan,
  });

  // Method untuk mengonversi JSON ke model Siswa
  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      idSiswa: json['id_siswa'],
      nisn: json['nisn'],
      nama: json['nama'],
      tanggalLahir: json['tanggal_lahir'],
      umur: json['umur'],
      jenisKelamin: json['jenis_kelamin'],
      sekolah: json['sekolah'],
      foto: json['foto'],
      dateCreated: json['date_created'],
      namaSekolah: json['nama_sekolah'],
      alamatSiswa: json['alamat_siswa'],
      noTeleponSiswa: json['no_telepon_siswa'],
      kelas: json['kelas'],
      idKelas: json['id_kelas'],
      totalRundungan: json['total_rundungan'],
    );
  }

  // Method untuk mengonversi model Siswa ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id_siswa': idSiswa,
      'nisn': nisn,
      'nama': nama,
      'tanggal_lahir': tanggalLahir,
      'umur': umur,
      'jenis_kelamin': jenisKelamin,
      'sekolah': sekolah,
      'foto': foto,
      'date_created': dateCreated,
      'nama_sekolah': namaSekolah,
      'alamat_siswa': alamatSiswa,
      'no_telepon_siswa': noTeleponSiswa,
      'kelas': kelas,
      'id_kelas': idKelas,
      'total_rundungan': totalRundungan,
    };
  }
}
