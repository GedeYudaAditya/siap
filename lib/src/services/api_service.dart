import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'https://siap.bulelengkab.go.id/api';

  // Example of a GET request
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');

      print('Token: $token');

      final response = await http.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Use the token in the Authorization header
        },
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error API: $e');
      throw Exception(e);
    }
  }

  // Example of a POST request
  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Payload " + data.toString());
    try {
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Error API: $e');
      throw Exception(e);
    }
  }

  // Put
  Future<Map<String, dynamic>> putData(
      String endpoint, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(data);
        throw Exception('Failed to put data');
      }
    } catch (e) {
      print('Error API: $e');
      throw Exception(e);
    }
  }

  // Delete
  Future<Map<String, dynamic>> deleteData(
      String endpoint, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  // Add other methods for PUT, DELETE, etc. as needed
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': username,
        'password': password,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
      String nisn, String username, String noTelp, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'nisn': nisn,
        'username': username,
        'no_telp': noTelp,
        'password': password,
      },
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
}
