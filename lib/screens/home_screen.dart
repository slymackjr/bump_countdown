import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../notifications_service.dart';
import '../database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lmpDate;
  DateTime? _eddDate;
  int _daysRemaining = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    NotificationService().initNotifications();
    _loadLastRecord();
  }

  void _loadLastRecord() async {
    List<Map<String, dynamic>> records = await _dbHelper.getRecords();
    if (records.isNotEmpty) {
      setState(() {
        _lmpDate = DateTime.parse(records.last['lmpDate']);
        _eddDate = DateTime.parse(records.last['eddDate']);
        _daysRemaining = records.last['daysRemaining'];
      });
    }
  }

  void _selectLmpDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _lmpDate) {
      setState(() {
        _lmpDate = picked;
        _eddDate = _lmpDate!.add(const Duration(days: 280)); // 40 weeks (280 days)
        _daysRemaining = _eddDate!.difference(DateTime.now()).inDays;
      });
      await _saveRecord();
      _setAlert();
    }
  }

  Future<void> _saveRecord() async {
    Map<String, dynamic> record = {
      'lmpDate': _lmpDate!.toIso8601String(),
      'eddDate': _eddDate!.toIso8601String(),
      'daysRemaining': _daysRemaining,
    };
    await _dbHelper.insertRecord(record);
  }

  void _setAlert() {
    if (_eddDate != null) {
      NotificationService().scheduleNotification(
        _eddDate!,
        'EDD Alert',
        'Today is the expected due date!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bump Countdown"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _lmpDate == null
                  ? "Select Last Menstrual Period (LMP) Date"
                  : "LMP Date: ${DateFormat.yMMMd().format(_lmpDate!)}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectLmpDate(context),
              child: const Text("Select LMP Date"),
            ),
            const SizedBox(height: 20),
            if (_eddDate != null)
              Column(
                children: [
                  Text(
                    "Estimated Due Date (EDD): ${DateFormat.yMMMd().format(_eddDate!)}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Days Remaining: $_daysRemaining",
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
