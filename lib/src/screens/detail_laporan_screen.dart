import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';

class DetailLaporanScreen extends StatefulWidget {
  const DetailLaporanScreen({super.key});

  @override
  State<DetailLaporanScreen> createState() => _DetailLaporanScreenState();
}

class _DetailLaporanScreenState extends State<DetailLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final apiService = ApiService();

  String? token;
  String? id;
  String? nama;
  int? role;

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  Future<bool> _updateLaporan(id, keterangan) async {
    // if (_formKey.currentState!.validate()) {
    final keterangan = _keteranganController.text;

    // call api service to update laporan
    try {
      final response = await apiService.putData('update_perundungan', {
        'id_laporan': id,
        'keterangan': keterangan,
      });

      print(response);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
    // } else {
    // return false;
    // }
  }

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama');
    role = prefs.getInt('role');
    setState(() {});
  }

  // set the text controller value
  void _setTextControllerValue(String value) {
    _keteranganController.text = value;
  }

  @override
  Widget build(BuildContext context) {
    // get arguments from previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Laporan;

    // set the text controller value
    _setTextControllerValue(args.keterangan ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, right: 16, left: 16),
                    alignment: Alignment.centerLeft,
                    child: Text('${args.klarifikasi}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 16, left: 16, top: 10, bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text('Detail Laporan:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.left),
                  ),
                  // text paragraph dari laporan
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(args.keterangan ?? '',
                            style: TextStyle(fontSize: 16, height: 1.5),
                            textAlign: TextAlign.justify),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // button untuk meligat log
            Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Row(
                children: [
                  role != RoleUtils.getRoleIndex(RoleUtils.student)
                      ? Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // navigate ke halaman log
                              Navigator.pushNamed(context, '/log',
                                  arguments: args);
                            },
                            child: Text('Lihat Log'),
                          ),
                        )
                      : SizedBox(),
                  (role == RoleUtils.getRoleIndex(RoleUtils.student) ||
                              role ==
                                  RoleUtils.getRoleIndex(RoleUtils.teacher)) &&
                          !(args.status == 'Selesai' ||
                              args.status == 'Selesai dari Siswa')
                      ? Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // pop up dialog untuk edit laporan
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Edit Laporan'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FormField(
                                          key: _formKey,
                                          builder: (field) => TextFormField(
                                            maxLines: 5,
                                            controller: _keteranganController,
                                            decoration: const InputDecoration(
                                              labelText: 'Keterangan',
                                              hintText:
                                                  'Tuliskan keterangan laporan disini...',
                                              border: OutlineInputBorder(),
                                              alignLabelWithHint: true,
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Keterangan tidak boleh kosong';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                showDialog(
                                                  barrierColor: Colors.white60,
                                                  context: context,
                                                  builder: (context) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                );
                                                // update laporan
                                                final result =
                                                    await _updateLaporan(
                                                        args.id,
                                                        _keteranganController
                                                            .text);

                                                if (result) {
                                                  // change the data in the previous screen
                                                  args.keterangan =
                                                      _keteranganController
                                                          .text;

                                                  setState(() {});

                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Berhasil mengupdate laporan')));
                                                } else {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Gagal mengupdate laporan')));
                                                }
                                              },
                                              child: Text('Save'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Edit'),
                          ),
                        )
                      : SizedBox(),
                  role == RoleUtils.getRoleIndex(RoleUtils.student) &&
                          (args.status == 'Selesai')
                      ? Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Pop up dialog to delete laporan
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Selesaikan Laporan'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menyelesaikan laporan ini?'),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Batal'),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.greenAccent,
                                              ),
                                              onPressed: () async {
                                                // pop up circle loading
                                                showDialog(
                                                  barrierColor: Colors.white60,
                                                  context: context,
                                                  builder: (context) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                );

                                                // Delete laporan
                                                await apiService.postData(
                                                    'konfirmasi_siswa', {
                                                  'id_laporan': args.id,
                                                }).then((value) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Berhasil'),
                                                        content: Text(
                                                            'Berhasil Melakuakn Perubahan'),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(() {});
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }).onError((error, stackTrace) {
                                                  Navigator.of(context).pop();
                                                  // Show error message pop up
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title:
                                                            const Text('Error'),
                                                        content: Text(
                                                            'Gagal menghapus laporan: $error'),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              },
                                              child: const Text('Selesaikan'),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith(
                              (states) => Colors.greenAccent,
                            )),
                            child: Text('Konfirmasi Selesai'),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
