import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void logout() async {
    await _auth.signOut();
    // Redirect to login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
              child: Text('Create CV'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/updateCv');
              },
              child: Text('Update CV'),
            ),
          ],
        ),
      ),
    );
  }
}
