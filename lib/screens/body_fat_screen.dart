import 'package:flutter/material.dart';

class BodyFatScreen extends StatefulWidget {
  const BodyFatScreen({super.key});

  @override
  State<BodyFatScreen> createState() => _BodyFatScreenState();
}

class _BodyFatScreenState extends State<BodyFatScreen> {
  double waist = 85;
  double neck = 40;
  double height = 170;
  double hip = 95; // For females only
  String gender = 'Male';
  double bodyFatPercentage = 0.0;
  String healthAdvice = '';
  bool hasCalculated = false; // Track if calculation has been done

  void calculateBFP() {
    FocusScope.of(context).unfocus(); // Close the keyboard

    setState(() {
      if (gender == 'Male') {
        bodyFatPercentage = 495 / (1.0324 - 0.19077 * (waist - neck) / height + 0.15456 * height / 100) - 450;
      } else {
        bodyFatPercentage = 495 / (1.29579 - 0.35004 * (waist + hip - neck) / height + 0.22100 * height / 100) - 450;
      }
      provideHealthAdvice();
      hasCalculated = true; // Mark calculation as done
    });
  }

  void provideHealthAdvice() {
    if (bodyFatPercentage < 0) {
      healthAdvice = "The calculated body fat percentage is negative, which may indicate an error in the measurements or calculation. Please ensure that all measurements are accurate.";
    } else if (gender == 'Male') {
      if (bodyFatPercentage < 6) {
        healthAdvice = "You are under the essential body fat percentage range. It's important to consult a healthcare professional to maintain healthy body fat.";
      } else if (bodyFatPercentage >= 6 && bodyFatPercentage <= 24) {
        healthAdvice = "Your body fat percentage is within the healthy range. Continue maintaining a balanced diet and exercise to stay fit.";
      } else {
        healthAdvice = "Your body fat percentage is above the healthy range. Consider adjusting your lifestyle with more physical activity and a healthier diet.";
      }
    } else {
      if (bodyFatPercentage < 16) {
        healthAdvice = "You are under the essential body fat percentage range. Please consult a healthcare professional for advice on healthy fat levels.";
      } else if (bodyFatPercentage >= 16 && bodyFatPercentage <= 30) {
        healthAdvice = "Your body fat percentage is within the healthy range. Keep up with a balanced diet and regular exercise.";
      } else {
        healthAdvice = "Your body fat percentage is above the healthy range. This could increase health risks, so it's advisable to focus on healthy living.";
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
              "Calculate Your Body Fat Percentage",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Gender selection
            DropdownButton<String>(
              value: gender,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                  hasCalculated = false; // Reset calculation flag
                });
              },
            ),
            const SizedBox(height: 20),
            // Waist input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Waist (cm)',
                prefixIcon: Icon(Icons.horizontal_rule),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => waist = double.tryParse(value) ?? waist,
            ),
            const SizedBox(height: 20),
            // Neck input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Neck (cm)',
                prefixIcon: Icon(Icons.arrow_upward),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => neck = double.tryParse(value) ?? neck,
            ),
            const SizedBox(height: 20),
            // Hip input for females
            if (gender == 'Female')
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Hip (cm)',
                  prefixIcon: Icon(Icons.horizontal_rule),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => hip = double.tryParse(value) ?? hip,
              ),
            const SizedBox(height: 20),
            // Calculate Button
            ElevatedButton(
              onPressed: calculateBFP,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Calculate BFP'),
            ),
            const SizedBox(height: 30),
            // Result display
            if (hasCalculated) // Display results only if calculated
              Column(
                children: [
                  Text(
                    'Body Fat Percentage: ${bodyFatPercentage.toStringAsFixed(2)}%',
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
                      healthAdvice,
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
