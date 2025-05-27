import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tender_ui/models/error.dart';
import 'package:tender_ui/services/errors_service.dart';

const Color jnjRed = Color(0xFFD71920);

class Errors extends StatefulWidget {
  @override
  _ErrorsState createState() => _ErrorsState();
}

class _ErrorsState extends State<Errors> {
  late Future<List<ErrorLog>> _logsFuture;
  String selectedLevel = 'ALL';

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  void _refreshLogs() {
    setState(() {
      _logsFuture = ErrorsService.fetchLogs();
    });
  }

  void _clearLogs() async {
    await ErrorsService.clearLogs();
    _refreshLogs();
  }

  Widget _buildIconForLevel(String level) {
    switch (level.toUpperCase()) {
      case 'DEBUG':
        return Icon(Icons.bug_report, color: Colors.grey);
      case 'INFO':
        return Icon(Icons.info_outline, color: Colors.blue);
      case 'WARNING':
        return Icon(Icons.warning_amber_rounded, color: Colors.orange);
      case 'ERROR':
        return Icon(Icons.error_outline, color: Colors.red);
      case 'CRITICAL':
        return Icon(Icons.report, color: Colors.deepPurple);
      default:
        return Icon(Icons.help_outline, color: Colors.black);
    }
  }

  List<ErrorLog> _filterLogs(List<ErrorLog> logs) {
    if (selectedLevel == 'ALL') return logs;
    return logs.where((log) => log.level.toUpperCase() == selectedLevel).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Session Logs'),
        backgroundColor: jnjRed,
        leading: IconButton(icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/'); 
            }
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: Colors.white), onPressed: _refreshLogs),
          IconButton(icon: Icon(Icons.delete, color: Colors.white), onPressed: _clearLogs),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              value: selectedLevel,
              decoration: InputDecoration(
                labelText: 'Filter by Level',
                border: OutlineInputBorder(),
              ),
              items: ['ALL', 'DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLevel = value;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ErrorLog>>(
              future: _logsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No logs available'));
                } else {
                  final filteredLogs = _filterLogs(snapshot.data!);
                  return ListView.builder(
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return ListTile(
                        leading: _buildIconForLevel(log.level),
                        title: Text(log.message),
                        subtitle: Text(log.timestamp),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
