import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page_mobile.dart';
import 'package:talk2docs/home/home_page_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState<T extends HomePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const HomePageWeb();
    } else {
      return const HomePageMobile();
    }
  }
}
