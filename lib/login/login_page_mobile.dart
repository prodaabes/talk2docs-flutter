import 'dart:convert';
import 'package:custom_signin_buttons/custom_signin_buttons.dart';
import 'package:flutter/material.dart';
import 'package:talk2docs/login/login_page.dart';
import 'package:crypto/crypto.dart';

class LoginPageMobile extends LoginPage {
  const LoginPageMobile({super.key});

  @override
  _LoginPageMobile createState() => _LoginPageMobile();
}

class _LoginPageMobile extends LoginPageState<LoginPageMobile> {
  var _isTitleVisible = false;

  // these controllers used to control the text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        _isTitleVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDFFFFFF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              color: const Color(0xFF000026),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: BackButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 100,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _isTitleVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            'Sign In to\nTalk2Docs',
                            style: TextStyle(
                              color: Color(0xFF3BBA9C),
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xFF3BBA9C)))),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email Address",
                          hintStyle: TextStyle(color: Colors.grey[700])),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xFF3BBA9C)))),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey[700])),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0), 
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0x55616161),
                            ),
                          ),
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Color(0xFF616161),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height:10),
                  FilledButton(
                    onPressed: () {
                      // get email and password from fields
                      final email = emailController.text;
                      final password = passwordController.text;

                      // hash the password using sha256
                      final passwordInBytes = utf8.encode(password);
                      final sha256password = sha256.convert(passwordInBytes);

                      login(context, email, sha256password.toString());
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      backgroundColor: const Color(0xFF000026),
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        button: Button.Google,
                        small: false,
                        onPressed: handleGoogleSignIn,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
