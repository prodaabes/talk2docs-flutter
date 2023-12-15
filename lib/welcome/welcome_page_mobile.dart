import 'package:flutter/material.dart';
import 'package:talk2docs/login/login_page.dart';
import 'package:talk2docs/signup/signup_page.dart';
import 'package:talk2docs/welcome/welcome_page.dart';

class WelcomePageMobile extends WelcomePage {
  const WelcomePageMobile({Key? key}) : super(key: key);

  @override
  _WelcomePageMobileState createState() => _WelcomePageMobileState();
}

class _WelcomePageMobileState extends WelcomePageState<WelcomePageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000026),
      body: Stack(
        children: [
         
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Image.asset('assets/images/welcome_page.png'),
          ),

          
          Positioned(
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Welcome to Talk2Docs',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Trajan Pro',
                        color: const Color(0xFF3BBA9C),
                      ),
                    ),
                  ),
                  Text(
                    'Unlock insights from your PDFs! Simply upload, and let the magic of information retrieval begin.',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white70, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white70, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
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
