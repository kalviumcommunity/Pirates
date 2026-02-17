import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetTreeDemoApp());
}

class WidgetTreeDemoApp extends StatelessWidget {
  const WidgetTreeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree & Reactive UI Demo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image Placeholder
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              
              // Helper Text to visualize tree
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Flutter Developer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Reactive UI Part
              if (_showDetails)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: const Text(
                    'This detail section is conditionally rendered based on the state variable `_showDetails`. When you tap the button, `setState()` is called, triggering a rebuild of the widget tree, which updates this visibility.',
                    textAlign: TextAlign.center,
                  ),
                )
              else
                const Text(
                  'Tap the button to see more details!',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              
              const SizedBox(height: 30),

              // Interactive Button
              ElevatedButton.icon(
                onPressed: _toggleDetails,
                icon: Icon(_showDetails ? Icons.visibility_off : Icons.visibility),
                label: Text(_showDetails ? 'Hide Details' : 'Show Details'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
