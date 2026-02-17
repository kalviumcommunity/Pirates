import 'package:flutter/material.dart';

void main() {
  runApp(const StatelessStatefulDemoApp());
}

class StatelessStatefulDemoApp extends StatelessWidget {
  const StatelessStatefulDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless vs Stateful Demo'),
        backgroundColor: Colors.indigo.shade100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Stateless Widget Usage
              const StaticHeaderWidget(
                title: 'Welcome to the Demo',
                subtitle: 'This section is a Stateless Widget. It never changes.',
              ),
              
              const SizedBox(height: 40),
              
              // Divider to separate sections
              const Divider(thickness: 2),
              
              const SizedBox(height: 40),

              // 2. Stateful Widget Usage
              const InteractivecounterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STATELESS WIDGET
// ---------------------------------------------------------------------------
// This widget is immutable. It is built once and never changes its internal state.
class StaticHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const StaticHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, size: 40, color: Colors.blueGrey),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STATEFUL WIDGET
// ---------------------------------------------------------------------------
// This widget maintains mutable state. It can rebuild itself when setState is called.
class InteractivecounterWidget extends StatefulWidget {
  const InteractivecounterWidget({super.key});

  @override
  State<InteractivecounterWidget> createState() => _InteractivecounterWidgetState();
}

class _InteractivecounterWidgetState extends State<InteractivecounterWidget> {
  int _counter = 0;
  bool _isActive = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
      _isActive = !_isActive; // Toggle active state for visual effect
    });
  }

  void _resetCounter() {
      setState(() {
          _counter = 0;
          _isActive = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isActive ? Colors.indigo.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Interactive Counter (Stateful)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _isActive ? Colors.indigo : Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                icon: const Icon(Icons.add),
                label: const Text('Increment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                  onPressed: _resetCounter,
                  child: const Text('Reset')
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap "Increment" to trigger setState() and rebuild this widget.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
