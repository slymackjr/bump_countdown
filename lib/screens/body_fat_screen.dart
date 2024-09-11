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

  void calculateBFP() {
    setState(() {
      if (gender == 'Male') {
        bodyFatPercentage = 495 / (1.0324 - 0.19077 * (waist - neck) / height + 0.15456 * height / 100) - 450;
      } else {
        bodyFatPercentage = 495 / (1.29579 - 0.35004 * (waist + hip - neck) / height + 0.22100 * height / 100) - 450;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Fat Percentage Calculator')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                  });
                },
              ),
              const SizedBox(height: 20),
              // Waist input
              TextField(
                decoration: const InputDecoration(labelText: 'Waist (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => waist = double.tryParse(value) ?? waist,
              ),
              const SizedBox(height: 20),
              // Neck input
              TextField(
                decoration: const InputDecoration(labelText: 'Neck (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => neck = double.tryParse(value) ?? neck,
              ),
              const SizedBox(height: 20),
              // Hip input for females
              if (gender == 'Female')
                TextField(
                  decoration: const InputDecoration(labelText: 'Hip (cm)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => hip = double.tryParse(value) ?? hip,
                ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: calculateBFP,
                child: const Text('Calculate BFP'),
              ),
              const SizedBox(height: 20),
              // Result display
              Text(
                'Body Fat Percentage: ${bodyFatPercentage.toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
