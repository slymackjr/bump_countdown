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
  String _healthAdvice = '';

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
        _provideHealthAdvice();
      });
    }
  }

  void _provideHealthAdvice() {
    if (_result != null) {
      if (_result! < 1500) {
        _healthAdvice = "Your BMR is relatively low. It is important to ensure that you meet your body's basic energy needs through a nutrient-dense diet. "
            "Consider foods rich in vitamins, minerals, and lean proteins to support your overall health.";
      } else if (_result! >= 1500 && _result! <= 2000) {
        _healthAdvice = "Your BMR is within the average range for many people. To maintain your weight, align your calorie intake with your BMR. "
            "Focus on a balanced diet of proteins, fats, and carbs to maintain energy levels.";
      } else {
        _healthAdvice = "Your BMR is on the higher side, which could indicate that your body requires more energy to function. Make sure to consume enough calories "
            "to meet your body's needs, focusing on nutrient-dense foods to support muscle maintenance and overall health.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Calculate Your Basal Metabolic Rate (BMR)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Gender selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Gender: "),
                  const SizedBox(width: 10),
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
                ],
              ),
              const SizedBox(height: 20),
              // Weight input
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Height input
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Age input
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateBmr,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Calculate BMR"),
              ),
              const SizedBox(height: 30),
              // Result display
              if (_result != null)
                Column(
                  children: [
                    Text(
                      "BMR: ${_result!.toStringAsFixed(2)} kcal/day",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Health advice display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        _healthAdvice,
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
    );
  }
}
