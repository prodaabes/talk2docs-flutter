import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page_mobile.dart';
import 'package:talk2docs/home/home_page_web.dart';
import 'package:talk2docs/utils.dart';
import 'package:talk2docs/welcome/welcome_page.dart';
import 'package:talk2docs/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState<T extends HomePage> extends State<T> {
  void logout() {
    Utils().showLoaderDialog(context, 'Logging Out');

    API().logout((isSuccess) {
      
      Navigator.pop(context);

      
      if (!isSuccess) {
        Utils().showSnackBar(context, 'Logout failed');
        return;
      }

     
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const HomePageWeb();
    } else {
      return const HomePageMobile();
    }
  }
}
