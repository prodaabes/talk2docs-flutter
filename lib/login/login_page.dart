import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/login/login_page_mobile.dart';
import 'package:talk2docs/login/login_page_web.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState<T extends LoginPage> extends State<T> {

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const LoginPageWeb();
    } else {
      return const LoginPageMobile();
    }
  }
}