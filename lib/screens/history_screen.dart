import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';

class HistoryScreen extends StatefulWidget {
  final int? selectedRecordId;
  final Function(Map<String, dynamic>) onRecordSelected;

  const HistoryScreen({
    super.key,
    required this.selectedRecordId,
    required this.onRecordSelected,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _records = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() async {
    List<Map<String, dynamic>> records = await _dbHelper.getRecords();
    setState(() {
      _records = records;
    });
  }

  void _deleteRecord(int id) async {
    await _dbHelper.deleteRecord(id);
    _loadRecords(); // Reload records after deletion
  }

  void _rateRecord(int id, int rating) async {
    await _dbHelper.updateRecord(id, {'rating': rating});
    _loadRecords(); // Reload records after rating
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        final lmpDate = DateTime.parse(record['lmpDate']);
        final eddDate = DateTime.parse(record['eddDate']);
        final daysRemaining = record['daysRemaining'];
        final childName = record['childName'] ?? 'No Name';
        final gender = record['gender'] ?? 'Not Specified';
        final rating = record['rating'] ?? 0;

        return Card(
          child: Column(
            children: [
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LMP: ${DateFormat.yMMMd().format(lmpDate)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "EDD: ${DateFormat.yMMMd().format(eddDate)}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " - Days: $daysRemaining",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Text("Child: $childName, Gender: $gender"),
                onTap: () => widget.onRecordSelected(record),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteRecord(record['id']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (starIndex) {
                    return Expanded(
                      child: IconButton(
                        icon: Icon(
                          rating > starIndex ? Icons.star : Icons.star_border,
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
    );
  }
}


