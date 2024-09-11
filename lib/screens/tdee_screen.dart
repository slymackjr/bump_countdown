import 'package:flutter/material.dart';

class TdeeScreen extends StatefulWidget {
  const TdeeScreen({super.key});

  @override
  State<TdeeScreen> createState() => _TdeeScreenState();
}

class _TdeeScreenState extends State<TdeeScreen> {
  final TextEditingController _bmrController = TextEditingController();
  double? _result;
  String _activityLevel = 'Sedentary';

  void _calculateTdee() {
    double bmr = double.tryParse(_bmrController.text) ?? 0;
    double multiplier;

    switch (_activityLevel) {
      case 'Lightly Active':
        multiplier = 1.375;
        break;
      case 'Moderately Active':
        multiplier = 1.55;
        break;
      case 'Very Active':
        multiplier = 1.725;
        break;
      case 'Super Active':
        multiplier = 1.9;
        break;
      default:
        multiplier = 1.2; // Default for Sedentary
        break;
    }

    setState(() {
      _result = bmr * multiplier;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Total Daily Energy Expenditure"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // BMR input
              TextField(
                controller: _bmrController,
                decoration: const InputDecoration(
                  labelText: 'BMR (kcal/day)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Activity level dropdown
              DropdownButton<String>(
                value: _activityLevel,
                items: const [
                  DropdownMenuItem(
                    value: 'Sedentary',
                    child: Text('Sedentary'),
                  ),
                  DropdownMenuItem(
                    value: 'Lightly Active',
                    child: Text('Lightly Active'),
                  ),
                  DropdownMenuItem(
                    value: 'Moderately Active',
                    child: Text('Moderately Active'),
                  ),
                  DropdownMenuItem(
                    value: 'Very Active',
                    child: Text('Very Active'),
                  ),
                  DropdownMenuItem(
                    value: 'Super Active',
                    child: Text('Super Active'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _activityLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateTdee,
                child: const Text("Calculate TDEE"),
              ),
              const SizedBox(height: 20),
              // Result display
              if (_result != null)
                Text(
                  "TDEE: ${_result!.toStringAsFixed(2)} kcal/day",
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
