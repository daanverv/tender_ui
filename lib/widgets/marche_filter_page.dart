import 'package:flutter/material.dart';
import 'package:tender_ui/services/filter_service.dart';

const Color jnjRed = Color(0xFFD71920);

class MarcheFilterPage extends StatefulWidget {
  @override
  _MarcheFilterPageState createState() => _MarcheFilterPageState();
}

class _MarcheFilterPageState extends State<MarcheFilterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cigCodeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _refNumController = TextEditingController();

  String _selectedStatus = '';
  String _selectedAuthority = '';

  final List<Map<String, String>> _statusOptions = [
    {'value': '', 'label': '-- Scegli uno stato --'},
    {'value': 'In corso', 'label': 'In corso'},
    {'value': 'In aggiudicazione', 'label': 'In aggiudicazione'},
    {'value': 'Conclusa', 'label': 'Conclusa'},
  ];

  final List<Map<String, String>> _authorityOptions = [
    {'value': '', 'label': '-- Scegli una stazione appaltante --'},
    {'value': 'Azienda Sanitaria Territoriale di Ancona', 'label': 'Azienda Sanitaria Territoriale di Ancona'},
    {
      'value': 'Azienda Sanitaria Territoriale di Ancona - Soggetto Aggregatore in avvalimento per Regione Marche',
      'label': 'Soggetto Aggregatore in avvalimento per Regione Marche'
    },
  ];

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Applying filters and scraping the results"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Marche Tender Filters'),
        backgroundColor: jnjRed,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure filters for Marche tenders',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: jnjRed,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _cigCodeController,
                        decoration: InputDecoration(
                          labelText: 'CIG Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedAuthority,
                        items: _authorityOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAuthority = value ?? '';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Contracting Authority',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: _statusOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value ?? '';
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _refNumController,
                        decoration: InputDecoration(
                          labelText: 'Reference Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.filter_alt),
                          label: Text('Apply Filters'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: jnjRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            _showLoadingDialog(context);

                            try {
                              final filterService = FilterService();
                              await filterService.submitMarcheFilters(
                                context: context,
                                cigCode: _cigCodeController.text,
                                title: _titleController.text,
                                contractingAuthority: _selectedAuthority,
                                status: _selectedStatus,
                                refNum: _refNumController.text,
                              );
                            } finally {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
