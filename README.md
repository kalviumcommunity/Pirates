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

---

## Hot Reload, Debug Console & DevTools Demonstration

This section documents the steps taken to complete the Sprint‑2 assignment on using Flutter's
Hot Reload, Debug Console, and DevTools together.

### Project Used
`lib/screens/stateless_stateful_demo.dart` (counter example) was launched with
`flutter run`.

### Steps Performed
1. Launched the app in debug mode from VS Code (`flutter run`).
2. Modified the text in `InteractiveCounterWidget` from
   `Text('$_counter')` to `Text('Counter: \\$_counter')`, saved the file, and
   pressed **r** in the terminal (or clicked the ⚡ Hot Reload button). The UI
   updated immediately without restarting.
3. Added a `debugPrint('increment pressed');` call inside `_incrementCounter()`
   and interacted with the button; the message appeared in the Debug Console.
4. Opened Flutter DevTools via the command palette (`> Flutter: Open DevTools`)
   and used the **Widget Inspector** to examine the widget tree, then switched to
   the **Performance** tab to view frame rendering graphs.

### Screenshots
*(place your own images in the repo and update paths accordingly)*

- Hot reload before/after: `docs/hot_reload_before.png` / `docs/hot_reload_after.png`
- Debug console log: `docs/debug_console.png`
- DevTools widget inspector: `docs/devtools_inspector.png`

### Reflection
- **Hot Reload** greatly speeds up UI iteration by preserving state while applying
  code changes. It's invaluable when fine‑tuning layouts or colors.
- **Debug Console** provides immediate visibility into runtime behavior and
  errors; using `debugPrint` keeps logs tidy.
- **DevTools** lets you visually inspect the widget hierarchy and profile
  performance, which is essential for diagnosing rendering bottlenecks.

These tools together create a highly productive development workflow and they
can easily be shared in a team (via screenshots or by opening DevTools on a
remote session).

---

## Multi‑Screen Navigation using Navigator and Named Routes

The sample project now includes a lightweight navigation demo that sits
alongside the existing authentication flow. The relevant files are:

* `lib/screens/navigation_home.dart`
* `lib/screens/navigation_second.dart`
* Updates to `lib/main.dart` (routes definition) and `lib/screens/login_screen.dart`
  (button to trigger the demo).

### Code snippets

**main.dart**
```dart
return MaterialApp(
  debugShowModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (_) => const LoginScreen(),
    '/navHome': (_) => const NavigationHome(),
    '/navSecond': (_) => const NavigationSecond(),
  },
);
```

**navigation_home.dart**
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/navSecond',
        arguments: 'Hello from Home!');
  },
  child: const Text('Go to Second Screen'),
);
```

**navigation_second.dart**
```dart
final message = ModalRoute.of(context)!.settings.arguments as String?;
...
ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text('Back to Home'),
);
```

### Screenshots (add your own)

- Home screen with the "Navigation demo (named routes)" button.
- Second screen showing the passed argument.
- Transition before/after via the Flutter UI.

### Reflection

* **Navigator stack** – Flutter keeps screens in a push/pop stack; calling
  `pushNamed` places a new route on top, and `pop` removes it, returning to the
  previous screen automatically.
* **Named routes** – Useful for decoupling navigation logic from widget
  constructors; centralised in `MaterialApp` makes refactoring easier in large
  apps.
* This setup lets the team add more pages by simply registering new routes
  without changing the push/pop logic scattered throughout the app.


