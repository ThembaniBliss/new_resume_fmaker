import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateCvScreen extends StatefulWidget {
  const CreateCvScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  String skills = '';
  String achievements = '';
  String certifications = '';

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
        'skills': skills,
        'achievements': achievements,
        'certifications': certifications,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV saved successfully.')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CV: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create CV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              onChanged: (value) {
                name = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              onChanged: (value) {
                phone = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                onChanged: (value) {
                  education = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your education',
                ),
              ),
              suggestionsCallback: (pattern) {
                return [
                  'Bachelor of Science',
                  'Master of Science',
                  'PhD',
                  'High School Diploma'
                ].where((suggestion) =>
                    suggestion.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  education = suggestion.toString();
                });
              },
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                onChanged: (value) {
                  experience = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your experience',
                ),
              ),
              suggestionsCallback: (pattern) {
                return [
                  'Software Engineer',
                  'Project Manager',
                  'Data Analyst',
                  'Marketing Specialist'
                ].where((suggestion) =>
                    suggestion.toLowerCase().contains(pattern.toLowerCase()));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                );
              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  experience = suggestion.toString();
                });
              },
            ),
            TextField(
              onChanged: (value) {
                skills = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your skills',
              ),
            ),
            TextField(
              onChanged: (value) {
                achievements = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your achievements',
              ),
            ),
            TextField(
              onChanged: (value) {
                certifications = value;
              },
              decoration: const InputDecoration(
                hintText: 'Enter your certifications',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: saveCv,
              child: const Text('Save CV'),
            ),
          ],
        ),
      ),
    );
  }
}
