import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database_helper.dart';
import 'history_screen.dart';
import 'alerts_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lmpDate;
  DateTime? _eddDate;
  int _daysRemaining = 0;
  int _selectedIndex = 0;
  int? _selectedRecordId;
  String _childName = '';
  String _gender = 'Not Specified'; // Default value
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadLastRecord();
  }

  void _loadLastRecord() async {
    List<Map<String, dynamic>> records = await _dbHelper.getRecords();
    if (records.isNotEmpty) {
      setState(() {
        _lmpDate = DateTime.parse(records.last['lmpDate']);
        _eddDate = DateTime.parse(records.last['eddDate']);
        _daysRemaining = records.last['daysRemaining'];
        _childName = records.last['childName'] ?? '';
        _gender = records.last['gender'] ?? 'Not Specified';
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
    }
  }

  Future<void> _saveRecord() async {
    Map<String, dynamic> record = {
      'lmpDate': _lmpDate?.toIso8601String(),
      'eddDate': _eddDate?.toIso8601String(),
      'daysRemaining': _daysRemaining,
      'childName': _childName,
      'gender': _gender,
    };
    if (_selectedRecordId != null) {
      await _dbHelper.updateRecord(_selectedRecordId!, record);
    } else {
      await _dbHelper.insertRecord(record);
    }
    _loadLastRecord(); // Reload records after saving
  }

  void _showEditChildDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Child Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Child Name'),
                onChanged: (value) {
                  setState(() {
                    _childName = value;
                  });
                },
                controller: TextEditingController(text: _childName),
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Not Specified', child: Text('Not Specified')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Gender'),
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
                await _saveRecord();
                _loadLastRecord();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _homeContent();
      case 1:
        return HistoryScreen(
          selectedRecordId: _selectedRecordId,
          onRecordSelected: _selectRecord,
        );
      case 2:
        return const AlertsScreen();
      default:
        return _homeContent();
    }
  }

  Widget _homeContent() {
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectLmpDate(context),
            child: const Text("Select LMP Date"),
          ),
          const SizedBox(height: 20),
          // Conditionally show the Edit Child Info button
          if (_eddDate != null && _daysRemaining > 0)
            ElevatedButton(
              onPressed: () => _showEditChildDialog(),
              child: const Text("Edit Child Info"),
            ),
          const SizedBox(height: 20),
          if (_eddDate != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Estimated Due Date (EDD): ${DateFormat.yMMMd().format(_eddDate!)}",
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Days Remaining: $_daysRemaining",
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Child Name Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.child_care), // Child icon
                    const SizedBox(width: 5),
                    Text("Child Name: $_childName"),
                  ],
                ),
                const SizedBox(height: 10),
                // Gender Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.transgender), // Gender icon
                    const SizedBox(width: 5),
                    Text("Gender: $_gender"),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _selectRecord(Map<String, dynamic> record) {
    setState(() {
      _lmpDate = DateTime.parse(record['lmpDate']);
      _eddDate = DateTime.parse(record['eddDate']);
      _daysRemaining = record['daysRemaining'];
      _childName = record['childName'] ?? '';
      _gender = record['gender'] ?? 'Not Specified';
      _selectedRecordId = record['id'];
      _selectedIndex = 0; // Navigate back to Home after selecting a record
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bump Countdown"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
