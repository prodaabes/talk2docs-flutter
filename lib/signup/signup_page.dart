import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/signup/signup_page_mobile.dart';
import 'package:talk2docs/signup/signup_page_web.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState<T extends SignupPage> extends State<T> {

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SignupPageWeb();
    } else {
      return const SignupPageMobile();
    }
  }
}