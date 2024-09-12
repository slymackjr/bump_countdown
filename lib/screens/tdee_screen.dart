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
  String _healthAdvice = '';

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
      _provideHealthAdvice();
    });
  }

  void _provideHealthAdvice() {
    if (_result != null) {
      if (_result! < 2000) {
        _healthAdvice = "Your TDEE is relatively low. Consider maintaining a balanced diet rich in nutrients to ensure you meet your daily energy needs, "
            "especially if you have an active lifestyle. Focus on quality carbs, proteins, and healthy fats.";
      } else if (_result! >= 2000 && _result! <= 3000) {
        _healthAdvice = "Your TDEE is within a healthy range for most people. To maintain your weight, keep your daily calorie intake close to this value. "
            "Ensure your meals are balanced with fruits, vegetables, lean proteins, and whole grains.";
      } else {
        _healthAdvice = "Your TDEE is higher than average, which indicates a highly active lifestyle. You might need to increase your calorie intake to match "
            "your energy output, focusing on nutrient-dense foods. Consider consulting a nutritionist to ensure you meet your daily requirements.";
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
                "Calculate Your Total Daily Energy Expenditure (TDEE)",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // BMR input
              TextField(
                controller: _bmrController,
                decoration: const InputDecoration(
                  labelText: 'Enter BMR (kcal/day)',
                  prefixIcon: Icon(Icons.local_fire_department),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Activity level dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Activity Level: "),
                  const SizedBox(width: 10),
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
                ],
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: _calculateTdee,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Calculate TDEE"),
              ),
              const SizedBox(height: 30),
              // Result display
              if (_result != null)
                Column(
                  children: [
                    Text(
                      "TDEE: ${_result!.toStringAsFixed(2)} kcal/day",
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
