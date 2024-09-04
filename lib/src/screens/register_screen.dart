import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spec_siandung/app_theme.dart';
import '../providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisnController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noHpController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController(); // Track the "Remember Me" checkbox state

  @override
  void initState() {
    super.initState();
    // Check "Remember Me" status when the login screen is initialized
    Provider.of<AuthProvider>(context, listen: false).checkRememberMe();
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://wa.me/+6282220202358');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 40, top: 100, bottom: 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Buat akun',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Halo, Selamat datang',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Theme(
                  data: AppTheme.lightTheme,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nisnController,
                        decoration: const InputDecoration(
                            labelText: 'NISN',
                            icon: Icon(Icons.account_circle_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your NISN';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            icon: Icon(Icons.person_outline_rounded)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _noHpController,
                        decoration: const InputDecoration(
                            labelText: 'No. HP',
                            icon: Icon(Icons.phone_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock_outline_rounded)),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            icon: Icon(Icons.lock_outline_rounded)),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      authProvider.isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButtonTheme(
                              data: Theme.of(context).elevatedButtonTheme,
                              child: ElevatedButton(
                                style: ElevatedButtonTheme.of(context).style,
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, dynamic> success =
                                        await authProvider.register(
                                      _nisnController.text,
                                      _usernameController.text,
                                      _noHpController.text,
                                      _passwordController.text,
                                    );
                                    print(success);
                                    if (success['status']) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/home');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(success['message'])),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                      const SizedBox(height: 20),
                      // Register text redirect
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/login');
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('NISN belum terdaftar? '),
                              GestureDetector(
                                onTap: () async {
                                  await _launchURL();
                                },
                                child: const Text(
                                  'Daftarkan NISN',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await authProvider.logout();
                      //     Navigator.of(context).pushReplacementNamed('/login');
                      //   },
                      //   child: const Text('Logout'),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
