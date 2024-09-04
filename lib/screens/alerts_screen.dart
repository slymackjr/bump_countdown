import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../database_helper.dart';
import '../main.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> _alerts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  // Schedule the notification
  void _scheduleNotification(Map<String, dynamic> alert) async {
    final alertDate = DateTime.parse(alert['alertDate']);
    final duration = alert['duration'] ?? 5;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alert['id'],
      alert['message'] ?? 'Due date is approaching!',
      'Ringtone: ${alert['ringtone'] ?? 'Default'}',
      tz.TZDateTime.from(alertDate.subtract(Duration(minutes: duration)), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Alert Notifications',
          channelDescription: 'Notification channel for alerts',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
      ),
      androidAllowWhileIdle: true, // Deprecated
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // New parameter
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }


  // Cancel a scheduled notification
  void _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Load alerts from the database
  void _loadAlerts() async {
    List<Map<String, dynamic>> alerts = await _dbHelper.getAlerts();
    setState(() {
      _alerts = alerts;
    });

    // Schedule notifications for all loaded alerts
    for (var alert in _alerts) {
      _scheduleNotification(alert);
    }
  }

  // Delete an alert and cancel its notification
  void _deleteAlert(int id) async {
    await _dbHelper.deleteAlert(id);
    _cancelNotification(id);
    _loadAlerts(); // Reload alerts after deletion
  }

  // Dialog to add or edit alerts
  void _showAlertDialog({Map<String, dynamic>? alert}) {
    String message = alert?['message'] ?? 'Due date is approaching!';
    String ringtone = alert?['ringtone'] ?? 'Default';
    int duration = alert?['duration'] ?? 5;
    int? historyId = alert?['historyId'];
    DateTime alertDate = alert != null
        ? DateTime.parse(alert['alertDate'])
        : DateTime.now();

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
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: alertDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(alertDate),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        alertDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: const Text('Select Alert Date & Time'),
              ),
              Text("Selected: ${DateFormat.yMMMd().add_jm().format(alertDate)}"),
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
                  'historyId': historyId,
                  'alertDate': alertDate.toIso8601String(),
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

  // Main widget build method
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

          return Card(
            child: ListTile(
              title: Text("Alert Date: ${DateFormat.yMMMd().add_jm().format(alertDate)}"),
              subtitle: Text("Message: $message, Ringtone: $ringtone, Duration: $duration min"),
              leading: const Icon(Icons.notification_important),
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
