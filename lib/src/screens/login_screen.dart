import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spec_siandung/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false; // Track the "Remember Me" checkbox state
  String appName = 'SIAP';
  @override
  void initState() {
    super.initState();
    // Check "Remember Me" status when the login screen is initialized
    Provider.of<AuthProvider>(context, listen: false).checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Theme(
                      data: AppTheme.lightTheme,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Masuk ke akun',
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Halo, Selamat datang disiap menjadi silahkan masukkan username dan password',
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                icon: Icon(Icons.alternate_email_rounded)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Masukkan username anda';
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
                                return 'Masukkan password anda';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         SizedBox(
                          //           height: 24,
                          //           width: 40,
                          //           child: Transform.scale(
                          //             scale: 0.6,
                          //             child: Switch(
                          //               value: _rememberMe,
                          //               onChanged: (value) {
                          //                 setState(() {
                          //                   _rememberMe = value;
                          //                 });
                          //               },
                          //               activeTrackColor: Colors.blue,
                          //               inactiveThumbColor: Colors.white,
                          //             ),
                          //           ),
                          //         ),
                          //         const Text('Remember Me',
                          //             style: TextStyle(fontSize: 12)),
                          //       ],
                          //     ),

                          //     // Add a "Forgot Password" button
                          //     // TextButton(
                          //     //   onPressed: () {
                          //     //     // Navigate to the "Forgot Password" screen
                          //     //     Navigator.of(context)
                          //     //         .pushNamed('/forgot-password');
                          //     //   },
                          //     //   child: const Text('Forgot Password?',
                          //     //       style: TextStyle(fontSize: 12)),
                          //     // ),
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                          authProvider.isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButtonTheme(
                                  data: Theme.of(context).elevatedButtonTheme,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Login',
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool success = await authProvider.login(
                                          _emailController.text,
                                          _passwordController.text,
                                          _rememberMe,
                                        );
                                        if (success) {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/home');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Username atau password salah. Coba lagi dengan username dan password yang benar.')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                          const SizedBox(height: 20),
                          // Register text redirect
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Belum punya akun? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/register');
                                },
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logo
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.8,
            child: Image.asset('lib/assets/logo.png',
                width: 80, height: 80, fit: BoxFit.contain),
          ),
        ]),
      ),
    );
  }
}
