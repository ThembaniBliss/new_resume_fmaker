import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreateCvScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const CreateCvScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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

  void saveCv() {
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

    _firestore.collection('cvs').doc(loggedInUser?.uid).set(cvData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV saved successfully.')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CV: $error')),
      );
    });
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

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: '${_nameController.text} CV.pdf');
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
