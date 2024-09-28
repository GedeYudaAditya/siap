import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/models/kelas.dart'; // Pastikan path sesuai dengan lokasi model

class TambahSiswaScreen extends StatefulWidget {
  const TambahSiswaScreen({super.key});

  @override
  State<TambahSiswaScreen> createState() => _TambahSiswaScreenState();
}

class _TambahSiswaScreenState extends State<TambahSiswaScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data Siswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Kelas"),
                value: _kelas,
                onChanged: _isLoadingKelas
                    ? null // Disable saat data masih loading
                    : (String? newValue) {
                        setState(() {
                          _kelas = newValue;
                        });
                      },
                items: _kelasList
                    .map((kelas) => DropdownMenuItem(
                          value: kelas.id,
                          child: Text(kelas.kelas ?? ''),
                        ))
                    .toList(),
                disabledHint:
                    Text("Memuat data kelas..."), // Pesan saat disabled
                validator: (value) {
                  if (value == null) {
                    return 'Kelas wajib dipilih';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tanggalLahirController,
                readOnly:
                    true, // Agar hanya dapat menginput melalui date picker
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  suffixIcon: Icon(Icons.calendar_today), // Ikon kalender
                ),
                onTap: () async {
                  // Tampilkan date picker ketika field ditekan
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now(), // Tanggal awal yang ditampilkan
                    firstDate: DateTime(1900), // Batas tanggal paling awal
                    lastDate: DateTime.now(), // Batas tanggal paling akhir
                    builder: (BuildContext context, Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: child,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    // Format dan set tanggal ke dalam controller
                    String formattedDate =
                        DateFormat('yyyy-MM-dd', 'id_ID').format(pickedDate);
                    // "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    setState(() {
                      _tanggalLahirController.text =
                          formattedDate; // Set hasil ke field
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal lahir wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _umurController,
                decoration: InputDecoration(labelText: "Umur"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Umur wajib diisi';
                  }
                  return null;
                },
              ),
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
                      await apiService.postData(
                        'insert_siswa',
                        {
                          'nisn': _nisnController.text,
                          'nama': _namaController.text,
                          'kelas': _kelas,
                          'tanggal_lahir': _tanggalLahirController.text,
                          'umur': _umurController.text,
                          'jenis_kelamin': _jenisKelamin,
                          'alamat': _alamatController.text,
                          'no_telepon': _noTeleponController.text,
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data Siswa Ditambahkan')));

                      Navigator.of(context).pushReplacementNamed('/siswa');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal Menambahkan Siswa')));
                    }
                  }
                },
                child: Text('Tambah Siswa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
