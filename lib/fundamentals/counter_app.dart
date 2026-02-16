import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 1. Understand Flutter's Architecture & 2. Explore the Widget Tree
// ---------------------------------------------------------------------------
// Flutter uses a widget tree to build the UI.
// - Everything is a widget (Text, Layouts, Buttons).
// - Widgets are immutable descriptions of part of the UI.
// - The framework diffs the widget tree and updates the render tree efficiently.
//
// Types of Widgets:
// - StatelessWidget: Immutable, static UI (e.g., Text, Icon).
// - StatefulWidget: Mutable, dynamic UI that can change over time (e.g., Counter).

void main() {
  runApp(const CounterApp());
}

// ---------------------------------------------------------------------------
// 3. Learn the Dart Language Essentials
// ---------------------------------------------------------------------------
// Dart concepts used here:
// - Classes & Objects: CounterApp, _CounterAppState are classes.
// - Inheritance: extends StatefulWidget, extends State.
// - Type Inference: var, int (though we use explicit types here for clarity).
// - Null Safety: String? (nullable), String (non-nullable).
// - Privacy: _CounterAppState (underscore means private to this file).

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

// ---------------------------------------------------------------------------
// 4. Build and Explain a Reactive UI
// ---------------------------------------------------------------------------
// This class holds the state for the CounterApp.
// When setState() is called, Flutter rebuilds this widget.

class _CounterAppState extends State<CounterApp> {
  // State variable
  int _counter = 0;

  // Method to increment the counter
  void _incrementCounter() {
    // setState() triggers a rebuild of the widget with the new state
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold implements the basic Material Design visual layout structure
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter & Dart Fundamentals'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                style: TextStyle(fontSize: 16),
              ),
              // Reactive UI: This Text widget displays the current value of _counter.
              // When setState is called, this part of the tree is rebuilt.
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
