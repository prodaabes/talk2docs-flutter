import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';

class HomePageWeb extends HomePage {
  const HomePageWeb({super.key});

  @override
  _HomePageWebState createState() => _HomePageWebState();
}

class _HomePageWebState extends HomePageState<HomePageWeb> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000026),
      body: Container()
    );
  }
}