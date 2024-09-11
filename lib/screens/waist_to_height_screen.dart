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

  void _calculateWhtR() {
    double waist = double.tryParse(_waistController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    if (height != 0) {
      setState(() {
        _result = waist / height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Waist-to-Height Ratio"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Waist circumference input
              TextField(
                controller: _waistController,
                decoration: const InputDecoration(
                  labelText: 'Waist Circumference (cm)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Optional: Handle input changes
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
                onChanged: (value) {
                  // Optional: Handle input changes
                },
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateWhtR,
                child: const Text("Calculate WHtR"),
              ),
              const SizedBox(height: 20),
              // Result display
              if (_result != null)
                Text(
                  "WHtR: ${_result!.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
