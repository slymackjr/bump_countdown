import 'package:flutter/material.dart';

class BmrScreen extends StatefulWidget {
  const BmrScreen({super.key});

  @override
  State<BmrScreen> createState() => _BmrScreenState();
}

class _BmrScreenState extends State<BmrScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  double? _result;

  void _calculateBmr() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    if (height > 0 && age > 0) {
      setState(() {
        if (_gender == 'Male') {
          _result = 10 * weight + 6.25 * height - 5 * age + 5;
        } else {
          _result = 10 * weight + 6.25 * height - 5 * age - 161;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basal Metabolic Rate"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gender selection
              DropdownButton<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Weight input
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Height input
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Age input
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateBmr,
                child: const Text("Calculate BMR"),
              ),
              const SizedBox(height: 20),
              // Result display
              if (_result != null)
                Text(
                  "BMR: ${_result!.toStringAsFixed(2)} kcal/day",
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
