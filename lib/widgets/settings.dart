import 'package:flutter/material.dart';

const Color jnjRed = Color(0xFFD71920);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController emailController = TextEditingController();
  bool sendInfo = false;
  bool sendWarning = false;
  bool sendError = true;

  void _onConfirm() {
    final email = emailController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: jnjRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Error report email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Send Info Messages'),
              value: sendInfo,
              onChanged: (val) => setState(() => sendInfo = val),
            ),
            SwitchListTile(
              title: const Text('Send Warning Messages'),
              value: sendWarning,
              onChanged: (val) => setState(() => sendWarning = val),
            ),
            SwitchListTile(
              title: const Text('Send Error Messages'),
              value: sendError,
              onChanged: (val) => setState(() => sendError = val),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: jnjRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm',
                style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
