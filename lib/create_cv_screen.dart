// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CreateCvScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const CreateCvScreen({Key? key}) : super(key: key);

  @override
  _CreateCvScreenState createState() => _CreateCvScreenState();
}

class _CreateCvScreenState extends State<CreateCvScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();
  final TextEditingController _languagesController = TextEditingController();

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 5, // allows for multi-line input for larger sections
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        // ignore: sort_child_properties_last
        child: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(_nameController.text,
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 8),
              pw.Text(_emailController.text,
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Text('Professional Summary:',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_summaryController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Education Details:',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_educationController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Professional Experience:',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_experienceController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Core Skills:', style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_skillsController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Certifications:',
                  style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_certificationsController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Languages:', style: const pw.TextStyle(fontSize: 18)),
              pw.Text(_languagesController.text,
                  style: const pw.TextStyle(fontSize: 14)),
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
            buildTextField(
                'Professional Summary', Icons.article, _summaryController),
            buildTextField(
                'Education Details', Icons.school, _educationController),
            buildTextField(
                'Professional Experience', Icons.work, _experienceController),
            buildTextField('Core Skills', Icons.build, _skillsController),
            buildTextField('Certifications', Icons.card_membership,
                _certificationsController),
            buildTextField('Languages', Icons.language, _languagesController),
            buildButton('Generate CV PDF', generatePdf),
          ],
        ),
      ),
    );
  }
}
