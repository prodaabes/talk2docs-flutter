import 'package:flutter/material.dart';
import 'package:talk2docs/login/login_page.dart';
import '../signup/signup_page_web.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPageWeb extends LoginPage {
  const LoginPageWeb({super.key});

  @override
  _LoginPageWebState createState() => _LoginPageWebState();
}

class _LoginPageWebState extends LoginPageState<LoginPageWeb>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;

  // Controllers used to control the text fields (get the text)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Track password visibility
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOut));

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(-2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeOut));

    _controller1.forward().then((_) {
      _controller2.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000026),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        children: [
          loginMenuWidget(
            onPressRegister: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupPageWeb(),
                ),
              );
            },
          ),
          loginBodyWidget(context),
        ],
      ),
    );
  }

  Widget loginBodyWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF3BBA9C),
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    WidgetSpan(
                      child: SlideTransition(
                        position: _slideAnimation1,
                        child: const Text(
                          'Sign In to',
                          style: TextStyle(
                            color: Color(0xFF3BBA9C),
                            fontSize: 75,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: SlideTransition(
                        position: _slideAnimation2,
                        child: const Text(
                          'Talk2Docs',
                          style: TextStyle(
                            color: Color(0xFF3BBA9C),
                            fontSize: 75,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 6,
          ),
          child: SizedBox(
            width: 320,
            child: _formLogin(),
          ),
        ),
      ],
    );
  }

  Widget loginMenuWidget({required VoidCallback onPressRegister}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Talk2Docs',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onPressRegister,
                child: _registerButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _registerButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF000026),
          ),
        ),
      ),
    );
  }

  Widget _formLogin() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Icon(
                _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () {
              // Get email and password from fields
              final email = emailController.text;
              final password = passwordController.text;

              // Hash the password using SHA-256
              final passwordInBytes = utf8.encode(password);
              final sha256password = sha256.convert(passwordInBytes).toString();

              // Try to login
              login(context, email, sha256password);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 42, 143, 120),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(child: Text("Sign In")),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Row(children: [
          Expanded(
            child: Divider(
              color: Colors.white,
              height: 50,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Or continue with",
              style: TextStyle(
                color: Color(0xFF3D606E),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white,
              height: 50,
            ),
          ),
        ]),
        const SizedBox(height: 20),
        _loginWithGoogleButton(
          isActive: true,
        ),
      ],
    );
  }

  Widget _loginWithGoogleButton({bool isActive = false}) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  spreadRadius: 2,
                  blurRadius: 7,
                )
              ],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]!),
            ),
      child: Center(
        child: Container(
          child: ElevatedButton(
            onPressed: handleGoogleSignIn,
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.asset(
                    'images/google.png',
                    width: 22,
                    height: 70,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
