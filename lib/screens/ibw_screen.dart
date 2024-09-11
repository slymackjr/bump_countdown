import 'package:flutter/material.dart';

class IbwScreen extends StatefulWidget {
  const IbwScreen({super.key});

  @override
  State<IbwScreen> createState() => _IbwScreenState();
}

class _IbwScreenState extends State<IbwScreen> {
  final TextEditingController _heightController = TextEditingController();
  String _gender = 'Male';
  double? _result;

  void _calculateIbw() {
    double heightCm = double.tryParse(_heightController.text) ?? 0;
    double heightInches = heightCm / 2.54;

    setState(() {
      if (_gender == 'Male') {
        _result = 50 + 2.3 * (heightInches - 60);
      } else {
        _result = 45.5 + 2.3 * (heightInches - 60);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ideal Body Weight"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gender dropdown
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
              // Height input
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateIbw,
                child: const Text("Calculate IBW"),
              ),
              const SizedBox(height: 20),
              // Result display
              if (_result != null)
                Text(
                  "IBW: ${_result!.toStringAsFixed(2)} kg",
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
