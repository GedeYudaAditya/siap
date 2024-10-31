import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/models/kelas.dart';
import 'package:spec_siandung/src/models/siswa.dart';

class EditSiswaScreen extends StatefulWidget {
  const EditSiswaScreen({super.key});

  @override
  State<EditSiswaScreen> createState() => _EditSiswaScreenState();
}

class _EditSiswaScreenState extends State<EditSiswaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields controllers
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();

  final apiService = ApiService();

  String? _kelas;
  List<Kelas> _kelasList = [];
  bool _isLoadingKelas = true;

  String? _jenisKelamin;

  @override
  void initState() {
    super.initState();
    // Fetch initial student data and kelas options
    _fetchKelasData();
  }

  Future<void> _fetchKelasData() async {
    try {
      final data = await apiService.fetchData('kelas');
      setState(() {
        _kelasList = Kelas.fromJsonList(data['data']);
        _isLoadingKelas = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingKelas = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kelas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the student data passed as arguments
    final args = ModalRoute.of(context)!.settings.arguments as Siswa;

    // Prepopulate form fields with existing student data
    _nisnController.text = args.nisn;
    _namaController.text = args.nama;
    _tanggalLahirController.text = args.tanggalLahir;
    _umurController.text = args.umur;
    _alamatController.text = args.alamatSiswa;
    _noTeleponController.text = args.noTeleponSiswa;
    _kelas = args.idKelas;
    _jenisKelamin = args.jenisKelamin;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Siswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                enabled: false,
                controller: _nisnController,
                decoration: InputDecoration(labelText: "NISN"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NISN wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: "Nama"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(labelText: "Kelas"),
              //   value: _kelas,
              //   onChanged: _isLoadingKelas
              //       ? null // Disable saat data masih loading
              //       : (String? newValue) {
              //           setState(() {
              //             _kelas = newValue;
              //           });
              //         },
              //   items: _kelasList
              //       .map((kelas) => DropdownMenuItem(
              //             value: kelas.id,
              //             child: Text(kelas.kelas ?? ''),
              //           ))
              //       .toList(),
              //   disabledHint:
              //       Text("Memuat data kelas..."), // Pesan saat disabled
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Kelas wajib dipilih';
              //     }
              //     return null;
              //   },
              // ),
              // TextFormField(
              //   controller: _tanggalLahirController,
              //   readOnly:
              //       true, // Agar hanya dapat menginput melalui date picker
              //   decoration: InputDecoration(
              //     labelText: "Tanggal Lahir",
              //     suffixIcon: Icon(Icons.calendar_today), // Ikon kalender
              //   ),
              //   onTap: () async {
              //     // Tampilkan date picker ketika field ditekan
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate:
              //           DateTime.now(), // Tanggal awal yang ditampilkan
              //       firstDate: DateTime(1900), // Batas tanggal paling awal
              //       lastDate: DateTime.now(), // Batas tanggal paling akhir
              //     );

              //     if (pickedDate != null) {
              //       // Format dan set tanggal ke dalam controller
              //       String formattedDate =
              //           DateFormat('yyyy-MM-dd', 'id_ID').format(pickedDate);
              //       // "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
              //       setState(() {
              //         _tanggalLahirController.text =
              //             formattedDate; // Set hasil ke field
              //       });
              //     }
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Tanggal lahir wajib diisi';
              //     }
              //     return null;
              //   },
              // ),
              // TextFormField(
              //   controller: _umurController,
              //   decoration: InputDecoration(labelText: "Umur"),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Umur wajib diisi';
              //     }
              //     return null;
              //   },
              // ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Jenis Kelamin"),
                value: _jenisKelamin,
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisKelamin = newValue;
                  });
                },
                items: ['Laki-laki', 'Perempuan']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Jenis kelamin wajib dipilih';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: "Alamat"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noTeleponController,
                decoration: InputDecoration(labelText: "No Telepon"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No telepon wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await apiService.putData(
                        'update_siswa', // Endpoint for updating
                        {
                          'id_siswa': args.idSiswa,
                          'nisn': _nisnController.text,
                          'nama': _namaController.text,
                          // 'kelas': _kelas,
                          // 'tanggal_lahir': _tanggalLahirController.text,
                          // 'umur': _umurController.text,
                          'jenis_kelamin': _jenisKelamin,
                          'alamat': _alamatController.text,
                          'no_telepon': _noTeleponController.text,
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Data Siswa Berhasil Diperbarui')));

                      Navigator.of(context).pushReplacementNamed('/siswa');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal Memperbarui Siswa')));
                    }
                  }
                },
                child: Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
