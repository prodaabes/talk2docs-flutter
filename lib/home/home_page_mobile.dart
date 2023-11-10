import 'package:flutter/material.dart';
import 'package:talk2docs/home/home_page.dart';

class HomePageMobile extends HomePage {
  const HomePageMobile({super.key});

  @override
  _HomePageMobile createState() => _HomePageMobile();
}

class _HomePageMobile extends HomePageState<HomePageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xDDFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000026),
        title: const Text(
          'Talk2Docs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              logout(); 
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Your App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3BBA9C),
                ),
              ),
              SizedBox(height: 20),
      
            ],
          ),
        ),
      ),
    );
  }
}
