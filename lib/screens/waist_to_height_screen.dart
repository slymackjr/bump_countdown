import 'package:flutter/material.dart';

class WhtRScreen extends StatefulWidget {
  const WhtRScreen({super.key});

  @override
  State<WhtRScreen> createState() => _WhtRScreenState();
}

class _WhtRScreenState extends State<WhtRScreen> {
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _result;
  String _healthAdvice = '';

  void _calculateWhtR() {
    double waist = double.tryParse(_waistController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    if (height != 0) {
      setState(() {
        _result = waist / height;
        _provideHealthAdvice();
      });
    }
  }

  void _provideHealthAdvice() {
    if (_result != null) {
      if (_result! < 0.40) {
        _healthAdvice = "Your Waist-to-Height Ratio is below the healthy range. This may indicate that you are underweight, "
            "and it's important to ensure you're getting enough nutrition.";
      } else if (_result! >= 0.40 && _result! <= 0.50) {
        _healthAdvice = "Your Waist-to-Height Ratio is within the healthy range. Keep maintaining a balanced diet and regular physical activity to stay healthy.";
      } else if (_result! > 0.50 && _result! <= 0.60) {
        _healthAdvice = "Your Waist-to-Height Ratio is above the healthy range. This could indicate a higher risk of heart disease or diabetes. "
            "Consider making lifestyle changes, such as increasing physical activity and monitoring your diet.";
      } else {
        _healthAdvice = "Your Waist-to-Height Ratio is significantly above the healthy range. This may put you at a higher risk for serious health conditions. "
            "It’s important to consult a healthcare professional for personalized advice.";
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
                "Calculate Your Waist-to-Height Ratio (WHtR)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Waist circumference input
              TextField(
                controller: _waistController,
                decoration: const InputDecoration(
                  labelText: 'Waist Circumference (cm)',
                  prefixIcon: Icon(Icons.horizontal_rule),
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
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateWhtR,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Calculate WHtR"),
              ),
              const SizedBox(height: 30),
              // Result display
              if (_result != null)
                Column(
                  children: [
                    Text(
                      "WHtR: ${_result!.toStringAsFixed(2)}",
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
