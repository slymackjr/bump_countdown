import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For handling file paths

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> _alerts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() async {
    List<Map<String, dynamic>> alerts = await _dbHelper.getAlerts();
    setState(() {
      _alerts = alerts;
    });
  }

  void _deleteAlert(int id) async {
    await _dbHelper.deleteAlert(id);
    _loadAlerts(); // Reload alerts after deletion
  }

  void _showAlertDialog({Map<String, dynamic>? alert}) {
    String message = alert?['message'] ?? 'Due date is approaching!';
    String ringtone = alert?['ringtone'] ?? 'Default';
    int duration = alert?['duration'] ?? 5;
    String? image = alert?['image'];
    int? historyId = alert?['historyId'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alert == null ? 'Add Alert' : 'Edit Alert'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Message'),
                controller: TextEditingController(text: message),
                onChanged: (value) => message = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Ringtone'),
                controller: TextEditingController(text: ringtone),
                onChanged: (value) => ringtone = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: duration.toString()),
                onChanged: (value) => duration = int.tryParse(value) ?? 5,
              ),
              const SizedBox(height: 10),
              if (image != null)
                Image.file(File(image), height: 100, width: 100, fit: BoxFit.cover),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _selectedImage = File(pickedImage.path);
                    });
                  }
                },
                child: const Text('Select Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final alertData = {
                  'message': message,
                  'ringtone': ringtone,
                  'duration': duration,
                  'image': _selectedImage?.path ?? image,
                  'historyId': historyId,
                };
                if (alert == null) {
                  await _dbHelper.insertAlert(alertData);
                } else {
                  await _dbHelper.updateAlert(alert['id'], alertData);
                }
                _loadAlerts();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAlertDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          final alertDate = DateTime.parse(alert['alertDate']);
          final message = alert['message'] ?? 'No Message';
          final ringtone = alert['ringtone'] ?? 'Default';
          final duration = alert['duration'] ?? 5;
          final image = alert['image'] ?? 'No Image';

          return Card(
            child: ListTile(
              title: Text("Alert Date: ${DateFormat.yMMMd().format(alertDate)}"),
              subtitle: Text("Message: $message, Ringtone: $ringtone, Duration: $duration min"),
              leading: image != 'No Image' ? Image.file(File(image), height: 50, width: 50, fit: BoxFit.cover) : const Icon(Icons.child_care),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showAlertDialog(alert: alert),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteAlert(alert['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
