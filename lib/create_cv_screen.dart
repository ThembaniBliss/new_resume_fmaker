// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

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

  List<String> _suggestions = [];
  final List<String> _skillsSuggestions = [
    "Project Management",
    "Communication Skills",
    "Technical Proficiency",
    "Problem Solving",
    "Leadership",
    "Team Management"
  ];
  final List<String> _experienceSuggestions = [
    "IT Consultant at Tech Solutions, Johannesburg (2018-2022)",
    "Civil Engineer at BuildRight, Cape Town (2015-2018): Supervised the structural integrity assessments of bridges and roads, reducing safety incidents by 25%.",
    "Marketing Manager at SunMark, Durban (2019-Present)"
  ];
  final List<String> _certificationsSuggestions = [
    "Chartered Accountant (CA) South Africa: A globally recognized financial qualification essential for accounting professionals.",
    "Certified Information Systems Auditor (CISA): Ideal for IT auditors, focusing on information systems control, assurance, and security professionals.",
    "Project Management Professional (PMP)®: Recognized worldwide, beneficial for project managers in any industry.",
    "General Mining Induction Safety Certification: Essential for professionals working in the mining industry in South Africa."
  ];
  final List<String> _languagesSuggestions = [
    "Xitsonga",
    "English",
    "Xhosa",
    "Venda",
    "Sepedi",
    "Isizulu"
  ];

  void _updateSuggestions(String query, List<String> source) {
    setState(() {
      _suggestions = source
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {List<String>? suggestionsSource}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: suggestionsSource != null
                ? (query) => _updateSuggestions(query, suggestionsSource)
                : null,
          ),
          if (suggestionsSource != null && _suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      controller.text = _suggestions[index];
                      setState(() {
                        _suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: onPressed,
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
              pw.Text(
                _nameController.text,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(_emailController.text,
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              pw.Text('Professional Summary:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(_summaryController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Education Details:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(_educationController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Professional Experience:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(_experienceController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Core Skills:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(_skillsController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Certifications:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text(_certificationsController.text,
                  style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 16),
              pw.Text('Languages:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
                'Professional Experience', Icons.work, _experienceController,
                suggestionsSource: _experienceSuggestions),
            buildTextField('Core Skills', Icons.build, _skillsController,
                suggestionsSource: _skillsSuggestions),
            buildTextField('Certifications', Icons.card_membership,
                _certificationsController,
                suggestionsSource: _certificationsSuggestions),
            buildTextField('Languages', Icons.language, _languagesController,
                suggestionsSource: _languagesSuggestions),
            buildButton('Generate CV PDF', generatePdf),
          ],
        ),
      ),
    );
  }
}
