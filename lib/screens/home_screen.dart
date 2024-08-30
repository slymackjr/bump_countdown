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
  int? _selectedRecordId;
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
        _selectedRecordId = records.last['id'];
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
    _loadLastRecord(); // Reload records after saving a new one
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

  void _editRecord(int id, DateTime lmpDate, DateTime eddDate, int daysRemaining) async {
    setState(() {
      _lmpDate = lmpDate;
      _eddDate = eddDate;
      _daysRemaining = daysRemaining;
    });
    await _dbHelper.updateRecord(id, {
      'lmpDate': lmpDate.toIso8601String(),
      'eddDate': eddDate.toIso8601String(),
      'daysRemaining': daysRemaining,
    });
  }

  void _deleteRecord(int id) async {
    await _dbHelper.deleteRecord(id);
    _loadLastRecord(); // Reload records after deletion
  }

  void _rateRecord(int id, int rating) async {
    await _dbHelper.updateRecord(id, {'rating': rating});
    _loadLastRecord(); // Reload records after rating
  }

  void _selectRecord(Map<String, dynamic> record) {
    setState(() {
      _lmpDate = DateTime.parse(record['lmpDate']);
      _eddDate = DateTime.parse(record['eddDate']);
      _daysRemaining = record['daysRemaining'];
      _selectedRecordId = record['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bump Countdown"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getRecords(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> records = snapshot.data!;

          return Padding(
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
                const SizedBox(height: 20),
                const Text(
                  "Pregnancy History",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> record = records[index];
                      DateTime lmpDate = DateTime.parse(record['lmpDate']);
                      DateTime eddDate = DateTime.parse(record['eddDate']);
                      int daysRemaining = record['daysRemaining'];
                      int? rating = record['rating'];
                      bool isSelected = record['id'] == _selectedRecordId;

                      return Card(
                        color: isSelected ? Colors.blue[100] : null,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "LMP: ${DateFormat.yMMMd().format(lmpDate)} - EDD: ${DateFormat.yMMMd().format(eddDate)}",
                              ),
                              subtitle: Text("Days Remaining: $daysRemaining"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editRecord(record['id'], lmpDate, eddDate, daysRemaining),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteRecord(record['id']),
                                  ),
                                ],
                              ),
                              onTap: () => _selectRecord(record),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(5, (starIndex) {
                                  return Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        rating != null && rating > starIndex ? Icons.star : Icons.star_border,
                                      ),
                                      color: Colors.amber,
                                      onPressed: () => _rateRecord(record['id'], starIndex + 1),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      );

                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

