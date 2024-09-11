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
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'images/male.png', // Male icon
                            width: 24,
                            height: 24,
                            color: gender == 'Male' ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Male",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
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
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'images/female.png', // Female icon
                            width: 24,
                            height: 24,
                            color: gender == 'Female' ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Female",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Height slider
              Text(
                "Height: $height cm",
                style: const TextStyle(fontSize: 20),
              ),
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
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (weight > 0) weight--;
                        });
                      },
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Weight: $weight kg",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          weight++;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Age increment/decrement
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (age > 0) age--;
                        });
                      },
                      icon: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Age: $age",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          age++;
                        });
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
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
          ),
        ),
      ),
    );
  }
}
