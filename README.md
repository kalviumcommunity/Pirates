# Stateless vs Stateful Widgets Demo

This interactive demo illustrates the fundamental difference between **Stateless** and **Stateful** widgets in Flutter. It combines both types in a single screen to demonstrate their behavior and usage.

## Concept Overview

### 1. Stateless Widgets
A `StatelessWidget` describes part of the user interface which is immutable. Once built, its properties cannot change. They are ideal for static content like icons, labels, or layout structures.

**Example from this project:** `StaticHeaderWidget`
> Displays a welcome message and subtitle. It receives data in its constructor but never changes dynamically.

```dart
class StaticHeaderWidget extends StatelessWidget {
  final String title;
  
  const StaticHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title); // This text will remain constant
  }
}
```

### 2. Stateful Widgets
A `StatefulWidget` can change dynamically. It maintains a `State` object that stores mutable data. When `setState()` is called, the widget rebuilds to reflect the new data.

**Example from this project:** `InteractiveCounterWidget`
> Maintains a counter variable (`_counter`). When the button is pressed, the state updates, and the number on the screen increments.

```dart
class InteractiveCounterWidget extends StatefulWidget {
  @override
  State<InteractiveCounterWidget> createState() => _InteractiveCounterWidgetState();
}

class _InteractiveCounterWidgetState extends State<InteractiveCounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++; // Updates the state and rebuilds the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_counter'),
        ElevatedButton(onPressed: _incrementCounter, child: Text('Increment')),
      ],
    );
  }
}
```

## Screenshots

| Initial State | Updated State (After Interaction) |
| :---: | :---: |
| ![Initial UI](path/to/screenshot_1.png) | ![Updated UI](path/to/screenshot_2.png) |
| *Counter starts at 0* | *Counter increments, background color changes* |

## Reflection

### When to use Stateless Widgets?
- Use them for UI parts that depend only on their configuration configuration (parameters passed in constructor) and do not need to change over time.
- Examples: Lists, Cards, Headers, Icons.
- **Benefit**: They are slightly more lightweight since they don't need to manage state objects.

### When are Stateful Widgets necessary?
- Use them when a part of the UI needs to change dynamically in response to user interaction, data updates, or animations.
- Examples: Forms, Checkboxes, Counters, Sliders.
- **Benefit**: They allow the app to be interactive and responsive.

### How does Flutter optimize updates?
Flutter keeps the UI performant by only rebuilding the widgets that need to be updated. When `setState()` is called within a Stateful widget, only *that specific widget* and its children are rebuilt, not the entire application.

## How to Run

To run this specific demo, use the following command:

```bash
flutter run -t lib/screens/stateless_stateful_demo.dart
```
