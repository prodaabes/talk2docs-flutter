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
      appBar: AppBar(
        backgroundColor: const Color(0xFF000026),
        title: const Text('Talk2Docs', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 15),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignupPage()));
            },
            child:
                const Text('Register', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              image: DecorationImage(
                image: AssetImage('assets/images/back_pdf.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            right: 0,
            child: Container(
              width: 450,
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 200.0),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Welcome to Talk2Docs',
                      style: TextStyle(
                        fontSize: 38.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Trajan Pro',
                        color: Color(0xFF000026),
                      ),
                    ),
                  ),
                  Text(
                    'Unlock insights from your PDFs!\nSimply upload, and let the magic of information retrieval begin.',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 40, 38, 38),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
