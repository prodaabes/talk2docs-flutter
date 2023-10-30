import 'package:flutter/material.dart';
import 'package:talk2docs/welcome/welcome_page.dart';

import '../login/login_page.dart';
import '../signup/signup_page.dart';

class WelcomePageWeb extends WelcomePage {
  const WelcomePageWeb({super.key});

  @override
  _WelcomePageWeb createState() => _WelcomePageWeb();
}

class _WelcomePageWeb extends WelcomePageState<WelcomePageWeb> {

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
