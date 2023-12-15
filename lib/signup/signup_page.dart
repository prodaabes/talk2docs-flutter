import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/signup/signup_page_mobile.dart';
import 'package:talk2docs/signup/signup_page_web.dart';
import 'package:talk2docs/api.dart';
import 'package:talk2docs/utils.dart';
import 'package:talk2docs/home/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState<T extends SignupPage> extends State<T> {
  final API authService = API(); 

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SignupPageWeb();
    } else {
      return const SignupPageMobile();
    }
  }

  void register(BuildContext context, String firstName, String lastName, String email, String password) {
    Utils().showLoaderDialog(context, 'Registering');

    authService.register(firstName, lastName, email, password, (isSuccess) {
      Navigator.pop(context);

      if (!isSuccess) {
        print("Error");
        Utils().showSnackBar(context, 'Registration Failed');
        return;
      }

      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }
}
