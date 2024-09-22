import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/laporan.dart';
import 'package:spec_siandung/src/models/log.dart';
import 'package:spec_siandung/src/models/status.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController dateMulaiController = TextEditingController();
  TextEditingController dateAkhirController = TextEditingController();
  TextEditingController pesanController = TextEditingController();
  String? status;
  String? statusCreate;
  List<DropdownMenuItem> dropDownItems = [];
  List<Status> statudData = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  String? token;
  String? id;
  String? nama;
  int? role;
  String? noTelp;

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama');
    role = prefs.getInt('role');
    noTelp = prefs.getString('noTelp');
    setState(() {});
  }

  DateTime? _selectedDateTimeAwal;

  Future<void> _selectDateTimeAwal(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTimeAwal = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateMulaiController.text =
              formatter.format(_selectedDateTimeAwal ?? DateTime.now());
        });
      }
    }
  }

  DateTime? _selectedDateTimeAkhir;

  Future<void> _selectDateTimeAkhir(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTimeAkhir = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateAkhirController.text =
              formatter.format(_selectedDateTimeAkhir ?? DateTime.now());
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getSharedPrefs();
      dropDownItems = [];
      statudData = [];
      _getStatus();
    });
  }

  Future<List<DropdownMenuItem>> _getStatus() async {
    try {
      final body = await apiService.fetchData(
        'status',
      );

      List<Status> status = await Status.fromJsonList(body['data']);

      for (var element in status) {
        print("Element: " + element.id.toString());
        dropDownItems.add(DropdownMenuItem(
          value: element.id,
          child: Text(element.status),
        ));
      }

      setState(() {
        statudData = status;
        dropDownItems = dropDownItems.reversed.toList();
      });

      return dropDownItems;
    } catch (e) {
      print(e);
      return dropDownItems;
    }
  }

  Future<void> _createLog({required id, required status}) async {
    final body = await apiService.postData(
      'create_log',
      {
        'id_laporan': id,
        'date_mulai': formatter.format(DateTime.now()),
        'date_selesai': '',
        'keterangan': keteranganController.text,
        'status': status,
      },
    );

    print('Response Create: $body');

    setState(() {});
  }

  Future<void> _kirimPesan({required id, required pesan}) async {
    final body = await apiService.postData(
      'wa_api',
      {
        'id_laporan': id,
        'pesan': pesan,
      },
    );

    print('Response Create: $body');

    setState(() {});
  }

  Future<bool> _updateLog(
      {required id,
      required text,
      required tglMulai,
      required tglSelesai,
      required status}) async {
    try {
      final body = await apiService.putData(
        'update_log',
        {
          'id_log': id,
          'keterangan': text,
          'date_time_mulai': tglMulai,
          'date_time_selesai': tglSelesai,
          'status': status
        },
      );

      print('Response Create: $body');

      setState(() {});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the arguments from the previous screen
    final args = ModalRoute.of(context)!.settings.arguments as Laporan;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: FutureBuilder(
              future: apiService.fetchData('log?id_laporan=' + args.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Log> logs =
                        Log.fromJsonList(snapshot.data!['data']['log']);
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 16, right: 16, left: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              '${snapshot.data!['data']['klasifikasi']}',
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
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pelapor : ${args.namaPelapor}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      textAlign: TextAlign.left),
                                  Text("Siswa : ${args.namaSiswa}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      textAlign: TextAlign.left),
                                ],
                              ),
                              Text(args.dateCreated ?? '',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        Divider(),
                        // text paragraph dari laporan
                        Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                  snapshot.data!['data']['keterangan'] ?? '',
                                  style: TextStyle(fontSize: 16, height: 1.5),
                                  textAlign: TextAlign.justify),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 10, bottom: 5),
                          alignment: Alignment.centerLeft,
                          child: Text('Log List:',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.left),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () async {
                                      setState(() {
                                        keteranganController.text =
                                            logs[index].keterangan;
                                        dateMulaiController.text =
                                            logs[index].dateTimeMulai;
                                        dateAkhirController.text =
                                            logs[index].dateTimeSelesai;
                                        status = logs[index].status;
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Edit Log'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FormField(
                                                    key: _formKey,
                                                    builder: (field) => Column(
                                                      children: [
                                                        // ListTile(
                                                        //   title: Text(
                                                        //       "Selected date & time: ${formatter.format(_selectedDateTimeAwal!)}"),
                                                        //   trailing: Icon(
                                                        //       Icons.calendar_today),
                                                        //   onTap: () =>
                                                        //       _selectDateTimeAwal(
                                                        //           context),
                                                        // ),
                                                        // ListTile(
                                                        //   title: Text(
                                                        //       "Selected date & time: ${formatter.format(_selectedDateTimeAkhir!)}"),
                                                        //   trailing: Icon(
                                                        //       Icons.calendar_today),
                                                        //   onTap: () =>
                                                        //       _selectDateTimeAkhir(
                                                        //           context),
                                                        // ),
                                                        TextFormField(
                                                          controller:
                                                              dateMulaiController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Tgl Mulai',
                                                            hintText:
                                                                'Tuliskan keterangan laporan disini...',
                                                            border:
                                                                OutlineInputBorder(),
                                                            alignLabelWithHint:
                                                                true,
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            _selectDateTimeAwal(
                                                                context);
                                                          },
                                                          readOnly: true,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Keterangan tidak boleh kosong';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              dateAkhirController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Tgl Akhir',
                                                            hintText:
                                                                'Tuliskan keterangan laporan disini...',
                                                            border:
                                                                OutlineInputBorder(),
                                                            alignLabelWithHint:
                                                                true,
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            _selectDateTimeAkhir(
                                                                context);
                                                          },
                                                          readOnly: true,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Keterangan tidak boleh kosong';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        TextFormField(
                                                          maxLines: 5,
                                                          controller:
                                                              keteranganController,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Keterangan',
                                                            hintText:
                                                                'Tuliskan keterangan laporan disini...',
                                                            border:
                                                                OutlineInputBorder(),
                                                            alignLabelWithHint:
                                                                true,
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
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
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        DropdownButtonFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Pilih Item',
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          value: Status
                                                              .getStatusId(
                                                                  status:
                                                                      status ??
                                                                          '-',
                                                                  data:
                                                                      statudData),
                                                          items: dropDownItems,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              status = value
                                                                  .toString();
                                                              print(status);
                                                            });
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Status tidak boleh kosong';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red),
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
                                                        // update laporan
                                                        final result = await _updateLog(
                                                            id: logs[index].id,
                                                            text:
                                                                keteranganController
                                                                    .text,
                                                            status: status,
                                                            tglMulai:
                                                                dateMulaiController
                                                                    .text,
                                                            tglSelesai:
                                                                dateAkhirController
                                                                    .text);

                                                        if (result) {
                                                          // change the data in the previous screen
                                                          args.keterangan =
                                                              keteranganController
                                                                  .text;

                                                          setState(() {});

                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'Berhasil mengupdate laporan')));
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
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
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    title: Text(
                                      logs[index].status,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(logs[index].keterangan,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10)),
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
                                              title:
                                                  const Text('Hapus Laporan'),
                                              content: const Text(
                                                  'Apakah Anda yakin ingin menghapus laporan ini?'),
                                              actions: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('Batal'),
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
                                                          await apiService
                                                              .deleteData(
                                                                  'delete_log',
                                                                  {
                                                                'id_log':
                                                                    logs[index]
                                                                        .id,
                                                              }).then((value) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            // Show error message pop up
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Error'),
                                                                  content: Text(
                                                                      'Gagal menghapus Log: $error'),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
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
                                                        child:
                                                            const Text('Hapus'),
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
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Pop up dialog to add new laporan
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Tambah Laporan'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      keteranganController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Keterangan',
                                                    hintText:
                                                        'Tuliskan keterangan laporan disini...',
                                                    border:
                                                        OutlineInputBorder(),
                                                    alignLabelWithHint: true,
                                                    hintStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  maxLines: 8,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    labelText: 'Pilih Item',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  items: dropDownItems,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      statusCreate =
                                                          value.toString();
                                                      print(statusCreate);
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Status tidak boleh kosong';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Batal'),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
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
                                                      // Add new laporan
                                                      await _createLog(
                                                              id: args.id,
                                                              status:
                                                                  statusCreate)
                                                          .then((value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }).onError((error,
                                                              stackTrace) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Show error message pop up
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Error'),
                                                              content: Text(
                                                                  '${error.toString()}'),
                                                              actions: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      });
                                                    },
                                                    child: const Text('Tambah'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add),
                                      Text('Tambah Log'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              role ==
                                          RoleUtils.getRoleIndex(
                                              RoleUtils.psychologist) ||
                                      role ==
                                          RoleUtils.getRoleIndex(
                                              RoleUtils.admin)
                                  ? Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Pop up dialog to add new laporan
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Kirim Pesan'),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        controller:
                                                            pesanController,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Pesan',
                                                          hintText:
                                                              'Tuliskan pesan...',
                                                          border:
                                                              OutlineInputBorder(),
                                                          alignLabelWithHint:
                                                              true,
                                                          hintStyle: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        maxLines: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Batal'),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              barrierColor:
                                                                  Colors
                                                                      .white60,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              },
                                                            );
                                                            // Add new laporan
                                                            await _kirimPesan(
                                                                    id: args.id,
                                                                    pesan:
                                                                        pesanController
                                                                            .text)
                                                                .then((value) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // Show error message pop up
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Error'),
                                                                    content: Text(
                                                                        'Pesan Gagal Dikirim: $error'),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
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
                                                          child: const Text(
                                                              'Kirim'),
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
                                            backgroundColor:
                                                WidgetStateColor.resolveWith(
                                          (states) => Colors.greenAccent,
                                        )),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.message),
                                            Text('Hubungi'),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Spacer()
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
