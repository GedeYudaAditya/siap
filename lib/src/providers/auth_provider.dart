// lib/src/providers/auth_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spec_siandung/src/models/user.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool _isLoggedIn = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password, bool rememberMe) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);

      // Handle the response, save tokens, etc.
      final token = response['data']['token'];

      // decode the token to get the user data
      final userData = json.decode(
        ascii.decode(
          base64.decode(
            base64.normalize(token.split(".")[1]),
          ),
        ),
      );

      print(userData);
      // {id: ID000040, nama: Cliff Miller Sanjaya, username: ciffaaa, role: 3, exp: 1718606824}

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }

      // get info user from api

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('id', userData['id']);
      await prefs.setString('nama', userData['nama']);

      final userInfo = await _apiService.fetchData('profile');

      // add id to user data confert to int
      userInfo['data']['id'] = userData['id'].toString();
      userInfo['data']['role'] = int.parse(userData['role'].toString());

      User user = User.fromJson(userInfo['data']);

      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('noTelp', user.noTelp ?? '');
      await prefs.setString('alamat', user.alamat ?? '');
      await prefs.setString('foto', user.foto ?? '');
      await prefs.setString('namaSekolah', user.namaSekolah ?? '');
      await prefs.setInt('role', int.parse(userData['role'].toString()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register a new user
  Future<Map<String, dynamic>> register(
      String nisn, String username, String noTelp, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _apiService.register(nisn, username, noTelp, password);
      // Handle the response, save tokens, etc.
      print("response register:" + response.toString());

      // if successful, login the user
      if (response['message'] == 'Siswa berhasil daftar') {
        final loginRes = await login(username, password, false);
        if (loginRes) {
          _isLoading = false;
          notifyListeners();
          return {'status': true, 'message': 'Login Berhasil'};
        } else {
          _isLoading = false;
          notifyListeners();
          return {
            'status': false,
            'message': 'Login Tidak Berhasil. Cobalah Login Kembali'
          };
        }
      } else {
        _isLoading = false;
        notifyListeners();
        return {'status': false, 'message': response['message']};
      }
    } on Exception catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return {'status': false, 'message': 'Terjadi Kesalahan.'};
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _isLoggedIn = token != null;

    // check token expired or not
    if (_isLoggedIn && token != null) {
      final userData = json.decode(
        ascii.decode(
          base64.decode(
            base64.normalize(token.split(".")[1]),
          ),
        ),
      );

      // final exp = userData['exp'] as int;
      // final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // if (exp < now) {
      //   _isLoggedIn = false;
      //   await prefs.remove('token');

      //   // remove other user data
      //   await prefs.remove('id');
      //   await prefs.remove('nama');
      //   await prefs.remove('role');
      //   await prefs.remove('username');
      //   await prefs.remove('email');
      //   await prefs.remove('noTelp');
      //   await prefs.remove('alamat');
      //   await prefs.remove('foto');
      //   await prefs.remove('namaSekolah');

      //   // logout
      //   await logout();
      // }
    }
    await prefs.setString('isloggedIn', _isLoggedIn.toString());
    notifyListeners();
  }

  Future<void> checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('username');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      // Automatically login if credentials exist
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('id');
    await prefs.remove('nama');
    await prefs.remove('role');
    await prefs.remove('email');
    await prefs.remove('noTelp');
    await prefs.remove('alamat');
    await prefs.remove('foto');
    await prefs.remove('namaSekolah');

    _isLoggedIn = false;
    await prefs.setString('isloggedIn', _isLoggedIn.toString());
    notifyListeners();
  }
}
