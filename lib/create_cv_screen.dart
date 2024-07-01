import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCvScreen extends StatefulWidget {
  @override
  _CreateCvScreenState createState() => _CreateCvScreenState();
}

class _CreateCvScreenState extends State<CreateCvScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String name = '';
  String email = '';
  String phone = '';
  String education = '';
  String experience = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  void saveCv() async {
    try {
      await _firestore.collection('cvs').doc(loggedInUser?.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'education': education,
        'experience': experience,
      });
      // Notify user of success
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create CV'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              onChanged: (value) {
                phone = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            TextField(
              onChanged: (value) {
                education = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your education',
              ),
            ),
            TextField(
              onChanged: (value) {
                experience = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your experience',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: saveCv,
              child: Text('Save CV'),
            ),
          ],
        ),
      ),
    );
  }
}
