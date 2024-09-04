import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';
// import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? token;
  String? id;
  String? nama;
  int? role;
  String? image;

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

  @override
  void initState() {
    super.initState();
    _getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(nama ?? 'Nama Pengguna'),
            accountEmail: Text(RoleUtils.getRole(role ?? 1)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(image ??
                  "https://ui-avatars.com/api/?name=" +
                      (nama ?? "") +
                      "&background=random"), // Placeholder image
            ),
          ),
          ListTile(
            title: const Text('Laporan'),
            leading: const Icon(Icons.article_outlined),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ListTile(
            title: const Text('Pengaturan'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/pengaturan');
            },
          ),
        ],
      ),
    );
  }
}
