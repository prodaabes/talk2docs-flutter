import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  String SERVER_URL = "http://192.168.0.130";

  Future<void> login(String email, String password, Function(bool isSuccess) callback) async {

    http.Response res = await http.post(
      Uri.parse("$SERVER_URL/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );

    if (res.statusCode != 200) {
      callback(false);
      return;
    }

    final data = jsonDecode(res.body);
    final token = data['token'];

    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('serverToken', token);

    callback(true);
  }
}