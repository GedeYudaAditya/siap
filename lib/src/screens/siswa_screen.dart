import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/siswa.dart';
import 'package:spec_siandung/src/models/user.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/widgets/app_bar_widget.dart';
import 'package:spec_siandung/src/widgets/drawer_widget.dart';

class SiswaScreen extends StatefulWidget {
  const SiswaScreen({super.key});

  @override
  State<SiswaScreen> createState() => _SiswaScreenState();
}

class _SiswaScreenState extends State<SiswaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final apiService = ApiService();

  String? token;
  String? id;
  String? nama;
  int? role;
  String? image;
  List<Siswa>? dataSiswa;

  bool dataIsReady = false;

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama') ?? '';
    role = prefs.getInt('role');
    image = prefs.getString('foto');

    setState(() {});
  }

  Future<void> _getSiswa() async {
    final body = await apiService.fetchData(
      'siswa',
    );

    final List<dynamic> listUser = body['data'];
    dataSiswa = listUser.map((e) => Siswa.fromJson(e)).toList();
    setState(() {
      dataSiswa = dataSiswa;
      print(dataSiswa);
      dataIsReady = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
    _getSiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
      drawer: const DrawerWidget(),
      body: Center(
        // Profile settings
        child: (dataIsReady)
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        itemCount: dataSiswa?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            onTap: () {
                              Navigator.of(context).pushNamed('/detail-siswa',
                                  arguments: dataSiswa![index]);
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  dataSiswa![index].foto.toString()),
                            ),
                            title: Text(dataSiswa![index].nama,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(dataSiswa![index].dateCreated,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                // Pop up dialog to delete laporan
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Hapus Laporan'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus laporan ini?'),
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
                                                onPressed: () async {
                                                  // pop up circle loading
                                                  showDialog(
                                                    barrierColor:
                                                        Colors.white60,
                                                    context: context,
                                                    builder: (context) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                                  );

                                                  // Delete laporan
                                                  await apiService.deleteData(
                                                      'delete_siswa', {
                                                    'id_siswa':
                                                        dataSiswa![index]
                                                            .idSiswa,
                                                  }).then((value) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    _getSiswa();
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Navigator.of(context).pop();
                                                    // Show error message pop up
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Error'),
                                                          content: Text(
                                                              'Gagal menghapus siswa: $error'),
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
                                                child: const Text('Hapus'),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: ElevatedButton(
                      child: Text('Tambah'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/tambah-siswa');
                      },
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
