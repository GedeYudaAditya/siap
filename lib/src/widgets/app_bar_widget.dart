import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/providers/auth_provider.dart';
import 'package:spec_siandung/src/utils/role_utils.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AppBarWidget({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Widget userAvatar = Row(
      children: [
        if (nama != null)
          CircleAvatar(
            backgroundImage: NetworkImage(image ??
                "https://ui-avatars.com/api/?name=" +
                    nama! +
                    "&background=random"), // Placeholder image
          ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama ?? "Nama Pengguna",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              RoleUtils.getRole(role ?? 1),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );

    List<Widget> actions = [
      // Notification
      // Logout button icon
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          authProvider.logout();
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    ];

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          widget.scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: userAvatar,
      actions: actions,
    );
  }
}
