import 'package:flutter/material.dart';
import 'package:spec_siandung/src/models/siswa.dart';

class DetailSiswaScreen extends StatefulWidget {
  const DetailSiswaScreen({super.key});

  @override
  State<DetailSiswaScreen> createState() => _DetailSiswaScreenState();
}

class _DetailSiswaScreenState extends State<DetailSiswaScreen> {
  @override
  Widget build(BuildContext context) {
    // get arguments from previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Siswa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Siswa'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card for displaying student details
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display photo if available
                      if (args.foto != null)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(args.foto!),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Display NISN
                      buildDetailRow('NISN', args.nisn),
                      const SizedBox(height: 10),

                      // Display Nama
                      buildDetailRow('Nama', args.nama),
                      const SizedBox(height: 10),

                      // Display Tanggal Lahir
                      // buildDetailRow('Tanggal Lahir', args.tanggalLahir),
                      // const SizedBox(height: 10),

                      // Display Umur
                      // buildDetailRow('Umur', '${args.umur} tahun'),
                      // const SizedBox(height: 10),

                      // Display Jenis Kelamin
                      buildDetailRow('Jenis Kelamin', args.jenisKelamin),
                      const SizedBox(height: 10),

                      // Display Sekolah
                      buildDetailRow('Sekolah', args.namaSekolah),
                      const SizedBox(height: 10),

                      // Display Alamat Siswa
                      buildDetailRow('Alamat', args.alamatSiswa),
                      const SizedBox(height: 10),

                      // Display No Telepon
                      buildDetailRow('No Telepon', args.noTeleponSiswa),
                      const SizedBox(height: 10),

                      // Display Kelas
                      // buildDetailRow('Kelas', args.kelas),
                      // const SizedBox(height: 10),

                      // Display Total Rundungan
                      buildDetailRow('Total Rundungan', args.totalRundungan),
                      const SizedBox(height: 20),

                      // Display Date Created
                      buildDetailRow('Terdaftar pada', args.dateCreated),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Button for editing student details
              ElevatedButton.icon(
                onPressed: () {
                  // Action for Edit Button
                  Navigator.pushNamed(context, '/edit-siswa', arguments: args);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Data Siswa'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build each detail row
  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
