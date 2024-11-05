import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/providers/auth_provider.dart';
import 'package:spec_siandung/src/services/api_service.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';
import 'package:spec_siandung/src/widgets/app_bar_widget.dart';
import 'package:spec_siandung/src/widgets/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // for text fields
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _namaSekolah = TextEditingController();
  final TextEditingController _passwordNewController = TextEditingController();
  final TextEditingController _passwordOldController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final TextEditingController _passwordHapusController =
      TextEditingController();

  final apiService = ApiService();

  String? token;
  String? id;
  String? nama;
  int? role;
  String? email;
  String? username;
  String? noTelp;
  String? image;
  String? password;
  String? namaSekolah;

  // get shared preferences
  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    nama = prefs.getString('nama');
    role = prefs.getInt('role');
    email = prefs.getString('email');
    username = prefs.getString('username');
    noTelp = prefs.getString('noTelp');
    password = prefs.getString('password');
    namaSekolah = prefs.getString('namaSekolah');

    image = prefs.getString('foto');
    setState(() {});
  }

  // set text fields
  void _setFields() {
    _emailController.text = email ?? '';
    _noTelpController.text = noTelp ?? '';
    _namaController.text = nama ?? '';
  }

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://wa.me/+6282220202358');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _setFields();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(scaffoldKey: _scaffoldKey),
      drawer: const DrawerWidget(),
      body: Center(
        // Profile settings
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              // Avatar and fields set image, name, phone, email.
              CircleAvatar(
                backgroundImage: NetworkImage(image ??
                    "https://ui-avatars.com/api/?name=" +
                        (nama ?? "") +
                        "&background=random"),
                radius: 100,
              ),
              SizedBox(height: 10),
              Text(
                nama ?? 'Nama Pengguna',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                RoleUtils.getRole(role ?? 1),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              // Fields for email, username, and phone number.
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormField(builder: (FormFieldState state) {
                  return Column(
                    children: <Widget>[
                      TextField(
                        controller: _namaController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Nama',
                          hintText: 'Nama',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _noTelpController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          labelText: 'No. Telp',
                          hintText: 'No. Telp',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        controller: _namaSekolah,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.school),
                          labelText: 'Nama Sekolah',
                          hintText: 'Nama Sekolah',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: const Text('Simpan'),
                          onPressed: () async {
                            // Save the changes to the shared preferences first.
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('nama', _namaController.text);
                            prefs.setString('email', _emailController.text);
                            prefs.setString('noTelp', _noTelpController.text);
                            // Then, update the user data in the API.
                            try {
                              await apiService.putData('update_profile', {
                                "email": _namaController.text,
                                "no_telp": _noTelpController.text,
                                "alamat": _noTelpController.text
                              });

                              // Finally, update the user data in the app.
                              setState(() {
                                nama = _namaController.text;
                                email = _emailController.text;
                                noTelp = _noTelpController.text;
                              });

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Berhasil'),
                                    content: Text('Data Terupdate'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              print(e);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Gagal Melakukan Perubahan'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                      SizedBox(height: 20),
                      Divider(),
                      SizedBox(height: 20),
                      Text("Keamanan"),
                      TextFormField(
                        controller: _passwordOldController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock_clock),
                          labelText: 'Password Lama',
                          hintText: 'Password Lama',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: _passwordNewController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password Baru',
                          hintText: 'Password Baru',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                      ),
                      TextFormField(
                        controller: _passwordConfController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.safety_check),
                          labelText: 'Konfirmasi Password',
                          hintText: 'Konfirmasi Password',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: const Text('Ubah Password'),
                          onPressed: () async {
                            // Then, update the user data in the API.
                            try {
                              await apiService.putData('ganti_password', {
                                "password_lama": _passwordOldController.text,
                                "password_now": _passwordNewController.text,
                                "password_confirm": _passwordConfController.text
                              });

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Berhasil'),
                                    content: Text('Data Terupdate'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } catch (e) {
                              print(e);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Gagal Melakukan Perubahan'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }),
                      SizedBox(height: 20),
                      // Link Reset Hapus Akun
                      (RoleUtils.getRoleIndex(RoleUtils.student) == role)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                // Dialog hapus akun, masukkan password untuk konfirmasi
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Hapus Akun'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              'Apakah Anda yakin ingin menghapus akun?'),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            controller:
                                                _passwordHapusController,
                                            decoration: const InputDecoration(
                                              icon: Icon(Icons.lock),
                                              labelText: 'Password',
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Masukkan password';
                                              }
                                              if (value != password) {
                                                return 'Password salah';
                                              }
                                              return null;
                                            },
                                            obscureText: true,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () async {
                                            // Then, update the user data in the API.
                                            try {
                                              if (_passwordHapusController
                                                      .text !=
                                                  password) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Konfirmasi Gagal'),
                                                      content: Text(
                                                          'Password yang Anda masukkan tidak sesuai'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                return;
                                              }

                                              await apiService.deleteData(
                                                  'delete_akun', {});

                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Berhasil'),
                                                    content: Text(
                                                        'Akun Telah Terhapus'),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              authProvider.logout();
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      '/login');
                                            } catch (e) {
                                              print(e);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text('Error'),
                                                    content: Text(
                                                        'Gagal Menghapus Akun'),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text('Hapus Akun'),
                            )
                          : Container(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
