import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateCvScreen extends StatefulWidget {
  @override
  _UpdateCvScreenState createState() => _UpdateCvScreenState();
}

class _UpdateCvScreenState extends State<UpdateCvScreen> {
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
    loadCvData();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  void loadCvData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('cvs').doc(loggedInUser?.uid).get();
      setState(() {
        name = doc['name'];
        email = doc['email'];
        phone = doc['phone'];
        education = doc['education'];
        experience = doc['experience'];
      });
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  void updateCv() async {
    try {
      await _firestore.collection('cvs').doc(loggedInUser?.uid).update({
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
        title: Text('Update CV'),
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
              controller: TextEditingController(text: name),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              controller: TextEditingController(text: email),
            ),
            TextField(
              onChanged: (value) {
                phone = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
              controller: TextEditingController(text: phone),
            ),
            TextField(
              onChanged: (value) {
                education = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your education',
              ),
              controller: TextEditingController(text: education),
            ),
            TextField(
              onChanged: (value) {
                experience = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your experience',
              ),
              controller: TextEditingController(text: experience),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: updateCv,
              child: Text('Update CV'),
            ),
          ],
        ),
      ),
    );
  }
}
