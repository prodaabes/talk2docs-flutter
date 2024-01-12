import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  void handleGoogleSignIn() async {
    try {
      // Initialize GoogleSignIn
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

      // Sign in with Google
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        String displayName = googleSignInAccount.displayName ?? "";
        String email = googleSignInAccount.email ?? "";

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        String accessToken = googleSignInAuthentication.accessToken ?? "";
        String idToken = googleSignInAuthentication.idToken ?? "";

        loginGoogle(context, email, accessToken,displayName);
      }
    } catch (error) {
      print('Error during Google sign-in: $error');
    }
  }

  void loginGoogle(BuildContext context, String googleEmail, String googleToken,String displayName) {
    Utils().showLoaderDialog(context, 'Logging In');

    authService.loginGoogle(googleEmail, googleToken,displayName,(isSuccess) {
   
      Navigator.pop(context);

     
      if (!isSuccess) {
        Utils().showSnackBar(context, 'Incorrect Credentials');
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));

    });
  }
}
