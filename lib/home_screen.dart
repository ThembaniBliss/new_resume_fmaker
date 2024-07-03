import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  HomeScreen({super.key});

  void logout(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Custom Button Style
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Background color
      foregroundColor: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/createCv');
              },
              child: const Text('Create CV'),
            ),
            const SizedBox(height: 20), // Add space between buttons
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushNamed(context, '/updateCv');
              },
              child: const Text('Update CV'),
            ),
          ],
        ),
      ),
    );
  }
}
