import 'package:flutter/material.dart';

class BmiResultScreen extends StatelessWidget {
  final Map<String, dynamic> bmiData;

  const BmiResultScreen({super.key, required this.bmiData});

  @override
  Widget build(BuildContext context) {
    double bmi = bmiData['bmi'];
    String gender = bmiData['gender'];
    String bmiCategory;
    Color bgColor;

    if (bmi < 16) {
      bmiCategory = 'Severely Underweight';
      bgColor = Colors.red;
    } else if (bmi < 18.5) {
      bmiCategory = 'Underweight';
      bgColor = Colors.orange;
    } else if (bmi < 24.9) {
      bmiCategory = 'Normal';
      bgColor = Colors.green;
    } else if (bmi < 29.9) {
      bmiCategory = 'Overweight';
      bgColor = Colors.yellow;
    } else {
      bmiCategory = 'Obese';
      bgColor = Colors.redAccent;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your BMI is:",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  bmi.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  bmiCategory,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Recalculate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
