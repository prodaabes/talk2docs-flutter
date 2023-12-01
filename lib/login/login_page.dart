import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:talk2docs/api.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/login/login_page_mobile.dart';
import 'package:talk2docs/login/login_page_web.dart';
import 'package:talk2docs/utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState<T extends LoginPage> extends State<T> {
  final API authService = API(); 

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const LoginPageWeb();
    } else {
      return const LoginPageMobile();
    }
  }

  void login(BuildContext context, String email, String password) {
    Utils().showLoaderDialog(context, 'Logging In');

    authService.login(email, password, (isSuccess) {
   
      Navigator.pop(context);

     
      if (!isSuccess) {
        Utils().showSnackBar(context, 'Incorrect Credentials');
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));

    });
  }
}
