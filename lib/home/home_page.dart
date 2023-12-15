import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/home/home_page_mobile.dart';
import 'package:talk2docs/home/home_page_web.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
import 'package:talk2docs/models/upload_file_model.dart';
import 'package:talk2docs/utils.dart';
import 'package:talk2docs/welcome/welcome_page.dart';
import 'package:talk2docs/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState<T extends HomePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HomePageWeb();
    } else {
      return const HomePageMobile();
    }
  }

  void getChats(Function(List<Chat> chats) callback) {
    API().getChats((isSuccess, chats) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error getting chats');
        return null;
      }

      callback(chats);
    });
  }

  void getMessages(String chatId, Function(List<Message> messages) callback) {
    API().getMessages(chatId, (isSuccess, messages) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error getting messages');
        return null;
      }

      callback(messages);
    });
  }

void removeFile(String chatId, String name, Function() callback) {
    API().removeFile(chatId, name, (isSuccess) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error removing file');
        return null;
      }

      callback();
    });
  }

  void uploadFiles(String chatId, List<UploadFile> files, Function() callback) {
    Utils().showLoaderDialog(context, 'Uploading File');

    API().uploadFiles(chatId, files, (isSuccess) {
      Navigator.pop(context);

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error uploading file');
        return null;
      }

      callback();
    });
  }

  void startChat(String chatId, Function() callback) {
    API().startChat(chatId, (isSuccess) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error starting chat');
        return null;
      }

      callback();
    });
  }

  void newChat(Function(String chatId) callback) {
    API().newChat((isSuccess, id) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error creating new chat');
        return null;
      }

      callback(id);
    });
  }

  void deleteChat(String chatId, Function() callback) {
    API().deleteChat(chatId, (isSuccess) {

      if (!isSuccess) {
        Utils().showSnackBar(context, 'Error deleting chat');
        return null;
      }

      callback();
    });
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
