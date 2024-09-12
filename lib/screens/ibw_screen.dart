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
  String _healthAdvice = '';

  void _calculateIbw() {
    double heightCm = double.tryParse(_heightController.text) ?? 0;
    double heightInches = heightCm / 2.54;

    setState(() {
      if (_gender == 'Male') {
        _result = 50 + 2.3 * (heightInches - 60);
      } else {
        _result = 45.5 + 2.3 * (heightInches - 60);
      }

      _provideHealthAdvice();
    });
  }

  void _provideHealthAdvice() {
    if (_result != null) {
      if (_result! < 50) {
        _healthAdvice = "Your ideal body weight is lower than average. "
            "Make sure you are consuming a balanced diet rich in proteins, healthy fats, and carbohydrates. "
            "Consider consulting a dietitian to help gain weight in a healthy manner.";
      } else if (_result! >= 50 && _result! <= 75) {
        _healthAdvice = "Your ideal body weight is within the recommended range. "
            "Maintain your current weight with regular physical activity, a healthy diet, and proper hydration.";
      } else {
        _healthAdvice = "Your ideal body weight is higher than average. "
            "Focus on maintaining a diet low in saturated fats and sugars while increasing physical activity. "
            "Consult a healthcare professional for a personalized plan to achieve a healthier weight.";
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
                "Calculate Your Ideal Body Weight (IBW)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Gender dropdown
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
              // Height input
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Enter Height (cm)',
                  prefixIcon: Icon(Icons.height),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateIbw,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Calculate IBW"),
              ),
              const SizedBox(height: 30),
              // Result display
              if (_result != null)
                Column(
                  children: [
                    Text(
                      "Your IBW: ${_result!.toStringAsFixed(2)} kg",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Health advice display
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Text(
                        _healthAdvice,
                        style: const TextStyle(fontSize: 16, color: Colors.teal),
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
