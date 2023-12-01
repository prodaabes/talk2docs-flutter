import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/home/home_page_mobile.dart';
import 'package:talk2docs/home/home_page_web.dart';
import 'package:talk2docs/models/chat.dart';
import 'package:talk2docs/models/message.dart';
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

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
