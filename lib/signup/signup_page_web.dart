import 'package:flutter/material.dart';
import 'package:talk2docs/signup/signup_page.dart';
import 'package:talk2docs/login/login_page.dart';

class SignupPageWeb extends SignupPage {
  const SignupPageWeb({Key? key}) : super(key: key);

  @override
  _SignupPageWebState createState() => _SignupPageWebState();
}

class _SignupPageWebState extends SignupPageState<SignupPageWeb>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000026),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          _signupMenuWidget(
            onPressSignIn: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
          _signupBodyWidget(context),
        ],
      ),
    );
  }

  Widget _signupBodyWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _slideAnimation1,
                child: const Text(
                  'Sign Up for',
                  style: TextStyle(
                    color: Color(0xFF3BBA9C),
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SlideTransition(
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
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 17),
          child: SizedBox(
            width: 320,
            child: _formRegister(),
          ),
        ),
      ],
    );
  }

  Widget _signupMenuWidget({required VoidCallback onPressSignIn}) {
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
          GestureDetector(
            onTap: onPressSignIn,
            child: _signinButton(),
          ),
        ],
      ),
    );
  }

  Widget _signinButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'Sign in ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF000026),
        ),
      ),
    );
  }

  Widget _formRegister() {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: InputDecoration(
            hintText: 'First Name',
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
          controller: lastNameController,
          decoration: InputDecoration(
            hintText: 'Last Name',
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
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
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
              // Get values from text fields
              final firstName = firstNameController.text;
              final lastName = lastNameController.text;
              final email = emailController.text;
              final password = passwordController.text;

              // Call the register method
              register(context, firstName, lastName, email, password);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 42, 143, 120),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(child: Text("Sign Up")),
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
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _loginWithButton(image: 'images/google.png'),
            _loginWithButton(image: 'images/github.png', isActive: true),
            _loginWithButton(image: 'images/facebook.png'),
          ],
        ),
      ],
    );
  }

  Widget _loginWithButton({required String image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  spreadRadius: 3,
                  blurRadius: 10,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]!),
            ),
      child: Center(
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      spreadRadius: 2,
                      blurRadius: 8,
                    )
                  ],
                )
              : const BoxDecoration(),
          child: Image.asset(
            image,
            width: 35,
          ),
        ),
      ),
    );
  }
}
