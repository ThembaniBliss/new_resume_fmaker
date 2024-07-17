// ignore_for_file: sort_child_properties_last, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreateCvScreen extends StatefulWidget {
  const CreateCvScreen({Key? key}) : super(key: key);

  @override
  _CreateCvScreenState createState() => _CreateCvScreenState();
}

class _CreateCvScreenState extends State<CreateCvScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final List<String> _skillsSuggestions = [
    'Programming',
    'Project Management',
    'Communication'
  ];

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.deepPurple),
        ),
      ),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: pw.Font.times(),
          italic: pw.Font.timesItalic(),
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(_nameController.text,
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Text('Graphic Designer',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Divider(),
              pw.Header(level: 1, child: pw.Text('Contact Information')),
              pw.Text(_emailController.text),
              pw.Text('123-456-7890'), // Placeholder
              pw.Text('www.example.com'), // Placeholder
              pw.Header(level: 1, child: pw.Text('Personal Details')),
              pw.Bullet(text: 'Date of Birth: ${_dateOfBirthController.text}'),
              pw.Bullet(
                  text: 'Marital Status: ${_maritalStatusController.text}'),
              pw.Bullet(text: 'Nationality: ${_nationalityController.text}'),
              pw.Bullet(text: 'Gender: ${_genderController.text}'),
              pw.Bullet(text: 'Race: ${_raceController.text}'),
              pw.Bullet(text: 'Languages: ${_languagesController.text}'),
              pw.Header(level: 1, child: pw.Text('Education')),
              pw.Text(_educationController.text),
              pw.Header(level: 1, child: pw.Text('Skills')),
              ..._skillsSuggestions.map((skill) => pw.Bullet(text: skill)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create CV'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Name', Icons.person, _nameController),
            buildTextField('Email', Icons.email, _emailController),
            buildTextField('Profile', Icons.description, _profileController),
            buildTextField('Date of Birth', Icons.cake, _dateOfBirthController),
            buildTextField('Marital Status', Icons.family_restroom,
                _maritalStatusController),
            buildTextField('Nationality', Icons.flag, _nationalityController),
            buildTextField('Gender', Icons.transgender, _genderController),
            buildTextField('Race', Icons.run_circle, _raceController),
            buildTextField('Languages', Icons.language, _languagesController),
            buildTextField('Education', Icons.school, _educationController),
            ElevatedButton(
              onPressed: generatePdf,
              child: const Text('Generate PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
