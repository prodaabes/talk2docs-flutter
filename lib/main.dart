import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talk2docs/home/home_page.dart';
import 'package:talk2docs/welcome/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Check if token exists
  String token = prefs.getString("serverToken") ?? "";
  
  runApp(MyApp(token));
}

class MyApp extends StatelessWidget {
  const MyApp(this.token, {super.key});

  final String token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Talk2Docs',
      home: token.isEmpty ? const WelcomePage() : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
