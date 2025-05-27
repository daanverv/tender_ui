import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color jnjRed = Color(0xFFD71920);


class AddWebsitePage extends StatefulWidget {
  const AddWebsitePage({super.key});

  @override
  State<AddWebsitePage> createState() => _AddWebsitePageState();
}

class _AddWebsitePageState extends State<AddWebsitePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();
  final Map<String, TextEditingController> _tagControllers = {
    'row_selector': TextEditingController(),
    'link_selector': TextEditingController(),
    'attachment_path': TextEditingController(),
    'download_all_selector': TextEditingController(),
    'allegati_button_selector': TextEditingController(),
    'attachment_link_selector': TextEditingController(),
    'prefix_to_remove': TextEditingController(),
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final websiteData = {
        'starting_url': _urlController.text,
        for (var entry in _tagControllers.entries) entry.key: entry.value.text,
      };

      // TODO: Send `websiteData` to your backend API
      print('Submitting: $websiteData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Website submitted successfully!')),
      );

      context.pop(); // Go back after submission
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    for (var controller in _tagControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
      title: const Text('Scrape Launcher'),
      backgroundColor: jnjRed,
      leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/'); 
        }
      },
    ),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Starting URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a URL' : null,
              ),
              const SizedBox(height: 20),
              ..._tagControllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key.replaceAll('_', ' ').toUpperCase(),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: entry.key.contains('keys') ? 5 : 1,
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Submit Website',
                style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD71920),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
