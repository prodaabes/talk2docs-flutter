import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static const String SERVER_URL = "http://127.0.0.1";

  Future<void> login(
      String email, String password, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$SERVER_URL/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      final data = jsonDecode(res.body);
      final token = data['token'];
      final fullName = data['fullName'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('serverToken', token);
      await prefs.setString( 'fullName',fullName );

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  Future<void> logout(Function(bool isSuccess) callback) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('serverToken');

      callback(true);
    } catch (e) {
      print("Exception during logout: $e");
      callback(false);
    }
  }

  Future<void> register(String firstName, String lastName, String email,
      String password, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$SERVER_URL/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      final data = jsonDecode(res.body);
      final token = data['token'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('serverToken', token);

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }
}
