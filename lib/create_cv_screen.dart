// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:printing/printing.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class CreateCvScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const CreateCvScreen({Key? key}) : super(key: key);

  @override
  _CreateCvScreenState createState() => _CreateCvScreenState();
}

class _CreateCvScreenState extends State<CreateCvScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _achievementsController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  void saveCv() async {
    final Map<String, String> cvData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'education': _educationController.text,
      'experience': _experienceController.text,
      'skills': _skillsController.text,
      'achievements': _achievementsController.text,
      'certifications': _certificationsController.text,
    };

    await _firestore.collection('cvs').doc(loggedInUser?.uid).set(cvData);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CV saved successfully.')),
    );

    // Navigate to a new page after saving
    // ignore: use_build_context_synchronously
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SuccessPage()));
  }

  Future<void> generateAndSharePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('CV for ${_nameController.text}',
                style: const pw.TextStyle(fontSize: 24)),
            pw.Text('Email: ${_emailController.text}'),
            pw.Text('Phone: ${_phoneController.text}'),
            pw.Text('Education: ${_educationController.text}'),
            pw.Text('Experience: ${_experienceController.text}'),
            pw.Text('Skills: ${_skillsController.text}'),
            pw.Text('Achievements: ${_achievementsController.text}'),
            pw.Text('Certifications: ${_certificationsController.text}'),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${_nameController.text} CV.pdf');
    await file.writeAsBytes(await pdf.save());

    final Email email = Email(
      body: 'Here is my CV.',
      subject: 'My CV',
      recipients: [_emailController.text],
      attachmentPaths: [file.path],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create CV')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(_nameController, 'Enter your name'),
            buildTextField(_emailController, 'Enter your email'),
            buildTextField(_phoneController, 'Enter your phone number'),
            buildTextField(_educationController, 'Enter your education'),
            buildTextField(_experienceController, 'Enter your experience'),
            buildTextField(_skillsController, 'Enter your skills'),
            buildTextField(_achievementsController, 'Enter your achievements'),
            buildTextField(
                _certificationsController, 'Enter your certifications'),
            const SizedBox(height: 20.0),
            ElevatedButton(onPressed: saveCv, child: const Text('Save CV')),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: generateAndSharePdf,
                child: const Text('Generate and Share PDF')),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Success')),
      body: const Center(child: Text('You have successfully created your CV!')),
    );
  }
}
