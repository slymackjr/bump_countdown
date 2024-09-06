import 'package:flutter/material.dart';

import 'bmi_result_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  int height = 170;
  int weight = 55;
  int age = 22;
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Gender selection
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    gender = 'Male';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: gender == 'Male' ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Male",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    gender = 'Female';
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: gender == 'Female' ? Colors.pink : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Female",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Height slider
          Text("Height: $height cm", style: const TextStyle(fontSize: 20)),
          Slider(
            value: height.toDouble(),
            min: 100,
            max: 250,
            divisions: 150,
            label: height.toString(),
            onChanged: (value) {
              setState(() {
                height = value.toInt();
              });
            },
          ),
          const SizedBox(height: 20),
          // Weight increment/decrement
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    if (weight > 0) weight--;
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Text("Weight: $weight kg", style: const TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () {
                  setState(() {
                    weight++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Age increment/decrement
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    if (age > 0) age--;
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              Text("Age: $age", style: const TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () {
                  setState(() {
                    age++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Calculate Button
          ElevatedButton(
            onPressed: () {
              if (gender.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select a gender first!")),
                );
              } else {
                double heightInMeters = height / 100;
                double bmi = weight / (heightInMeters * heightInMeters);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BmiResultScreen(
                      bmiData: {'bmi': bmi, 'gender': gender},
                    ),
                  ),
                );
              }
            },
            child: const Text("Calculate BMI"),
          ),
        ],
    );
  }
}
