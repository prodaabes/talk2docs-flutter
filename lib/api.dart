import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:talk2docs/models/upload_file_model.dart';

class API {
  static const String SERVER_URL = "http://192.168.0.143";
  static const String SOCKET_URL = "ws://192.168.0.143:8765";

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
      final fullName = data['fullName'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', fullName);
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
      final id = data['id'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', "$firstName $lastName");
      await prefs.setString('serverToken', token);
      await prefs.setString('id', id);

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  Future<void> getChats(
      Function(bool isSuccess, List<Chat> chats) callback) async {
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
        chats.add(Chat(c['id'], c['title'], files));
      }

      callback(true, chats);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false, []);
    }
  }

  // this method used to get the messages for specific chatId
  Future<void> getMessages(String id,
      Function(bool isSuccess, List<Message> messages) callback) async {
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
        messages.add(Message(
            id: m['id'],
            chatId: m['chatId'],
            isQuestion: m['isQuestion'],
            content: m['content']));
      }

      callback(true, messages);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false, []);
    }
  }

  // this method used to upload files in specific chat
  Future<void> uploadFiles(String id, List<UploadFile> files,
      Function(bool isSuccess) callback) async {
    try {
      final request = http.MultipartRequest(
          "POST", Uri.parse("$SERVER_URL/chats/$id/upload-docs"));
      request.headers['Content-Type'] = "multipart/form-data";
      request.fields['chatId'] = id;

      for (var f in files) {
        final multipart = await http.MultipartFile.fromBytes('files', f.bytes,
            filename: f.name);
        request.files.add(multipart);
      }

      final res = await http.Response.fromStream(await request.send());

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  // this method used to remove a file in specific chat
  Future<void> removeFile(
      String id, String name, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$SERVER_URL/chats/$id/remove-doc"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'chatId': id,
          'fileName': name,
        }),
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  Future<void> startChat(
      String chatId, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$SERVER_URL/chats/$chatId/start"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'chatId': chatId}),
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  Future<void> newChat(Function(bool isSuccess, String id) callback) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id") ?? "";

    final http.Response res = await http.post(
      Uri.parse("$SERVER_URL/chats/new"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'userId': id}),
    );

    if (res.statusCode != 200) {
      print("HTTP Request Error: ${res.statusCode}");
      callback(false, "");
      return;
    }

    final data = jsonDecode(res.body);
    final chatId = data['id'];

    callback(true, chatId);

  }

  Future<void> deleteChat(
      String chatId, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.delete(
        Uri.parse("$SERVER_URL/chats/$chatId/delete"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'chatId': chatId}),
      );

      if (res.statusCode != 200) {
        print("HTTP Request Error: ${res.statusCode}");
        callback(false);
        return;
      }

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }

  Future<void> loginGoogle(String googleEmail, String googleToken,
      String displayName, Function(bool isSuccess) callback) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$SERVER_URL/login-google"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': googleEmail,
          'displayName': displayName,
          'token': googleToken,
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
      final fullName = data['fullName'];

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', fullName);
      await prefs.setString('serverToken', token);
      await prefs.setString('id', id);

      callback(true);
    } catch (e) {
      print("Exception during API request: $e");
      callback(false);
    }
  }
}
