import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';

class API {
  static const String SERVER_URL = "http://192.168.0.130";

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
      final id = data['id'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('serverToken', token);
      await prefs.setString('id', id);

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
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

  // this method used to get the logged in user chats
  Future<void> getChats(Function(bool isSuccess, List<Chat> chats) callback) async {
    try {

      // get the saved user id
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getString("id") ?? "";

      final http.Response res = await http.get(
        Uri.parse("$SERVER_URL/chats/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false, []);
        return;
      }

      // get the json data
      final data = jsonDecode(res.body);

      // convert data to chats list
      List<Chat> chats = [];
      for (var c in data['chats']) {
        // convert file names to string
        List<String> files = [];
        for (var f in c['files']) {
          files.add(f.toString());
        }
        chats.add(Chat(id: c['id'], userId: c['userId'], title: c['title'], files: files));
      }

      callback(true, chats);

    } catch (e) {
      print("Exception during API request: $e");
      callback(false, []);
    }
  }

  // this method used to get the messages for specific chatId
  Future<void> getMessages(String id, Function(bool isSuccess, List<Message> messages) callback) async {
    try {

      final http.Response res = await http.get(
        Uri.parse("$SERVER_URL/messages/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false, []);
        return;
      }

      // get the json data
      final data = jsonDecode(res.body);

      // convert data to chats list
      List<Message> messages = [];
      for (var m in data['messages']) {
        messages.add(Message(id: m['id'], chatId: m['chatId'], isQuestion: m['isQuestion'], content: m['content']));
      }

      callback(true, messages);

    } catch (e) {
      print("Exception during API request: $e");
      callback(false, []);
    }
  }
}
