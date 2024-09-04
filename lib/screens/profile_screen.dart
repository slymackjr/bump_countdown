import 'package:flutter/material.dart';
import '../database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _name = '';
  String _email = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile from the database
  void _loadProfile() async {
    Map<String, dynamic>? profile = await _dbHelper.getProfile();
    if (profile != null) {
      setState(() {
        _name = profile['name'] ?? '';
        _email = profile['email'] ?? '';
        _phone = profile['phone'] ?? '';
      });
    }
  }

  // Save profile to the database
  Future<void> _saveProfile() async {
    Map<String, dynamic> profile = {
      'name': _name,
      'email': _email,
      'phone': _phone,
    };
    await _dbHelper.updateProfile(profile);
    _loadProfile(); // Reload profile after saving
  }

  // Show dialog to edit profile information
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                controller: TextEditingController(text: _name),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                controller: TextEditingController(text: _email),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                controller: TextEditingController(text: _phone),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _saveProfile();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: $_email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Phone: $_phone', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showEditProfileDialog,
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
