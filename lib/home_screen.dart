import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  HomeScreen({super.key});

  void logout() async {
    await _auth.signOut();
    // Redirect to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createCv');
              },
              child: const Text('Create CV'),
            ),
            ElevatedButton(
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
