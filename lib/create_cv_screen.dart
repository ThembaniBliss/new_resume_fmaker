// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, unused_field

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'ai_service.dart';

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

  // Define suggestions lists
  // ignore: prefer_final_fields
  List<String> _experienceSuggestions = [
    'Manager',
    'Software Engineer',
    'Project Manager'
  ];
  final List<String> _skillsSuggestions = [
    'Programming',
    'Project Management',
    'Communication'
  ];
  final List<String> _certificationsSuggestions = [
    'PMP',
    'AWS Certified',
    'Scrum Master'
  ];
  final List<String> _languagesSuggestions = ['English', 'Spanish', 'French'];
  List<String> _suggestions = [];

  // Define the method to update suggestions based on input
  void _updateSuggestions(String query, List<String> suggestionsSource) {
    setState(() {
      _suggestions = suggestionsSource
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _generateText(
      TextEditingController controller, String prompt) async {
    final generatedText = await AiService.generateText(prompt);
    setState(() {
      controller.text = generatedText;
    });
  }

  Widget buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    List<String>? suggestionsSource,
    bool useAi = false,
    String? aiPrompt,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
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
              ),
              if (useAi && aiPrompt != null)
                IconButton(
                  icon: const Icon(Icons.lightbulb),
                  onPressed: () => _generateText(controller, aiPrompt),
                ),
            ],
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
              // Other text components similar to this
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
            // More fields similar to this
            buildButton('Generate CV PDF', generatePdf),
          ],
        ),
      ),
    );
  }
}
