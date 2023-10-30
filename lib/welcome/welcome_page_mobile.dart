import 'package:flutter/material.dart';
import 'package:talk2docs/login/login_page.dart';
import 'package:talk2docs/signup/signup_page.dart';
import 'package:talk2docs/welcome/welcome_page.dart';

class WelcomePageMobile extends WelcomePage {
  const WelcomePageMobile({super.key});

  @override
  _WelcomePageMobile createState() => _WelcomePageMobile();
}

class _WelcomePageMobile extends WelcomePageState<WelcomePageMobile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDFFFFFF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: const Color(0xFF000026)),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupPage()));
              },
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: const Color(0xFF000026)),
              child: const Text('Register'),
            )
          ],
        ),
      )
    );
  }
}
