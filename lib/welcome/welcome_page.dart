import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/welcome/welcome_page_mobile.dart';
import 'package:talk2docs/welcome/welcome_page_web.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState<T extends WelcomePage> extends State<T> {

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WelcomePageWeb();
    } else {
      return const WelcomePageMobile();
    }
  }
}