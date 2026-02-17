# Widget Tree & Reactive UI Demo

This project demonstrates Flutter's Widget Tree structure and its Reactive UI model. The app features a profile card where clicking a button toggles additional details, showcasing how `setState()` triggers UI updates.

## Widget Tree Hierarchy

Below is a representation of the widget tree for the `ProfileScreen` widget used in this demo:

```
MaterialApp
 ┗ Scaffold
    ┣ AppBar (Title: "Widget Tree & Reactive UI Demo")
    ┗ Body (Center)
       ┗ Padding
          ┗ Column
             ┣ CircleAvatar (Profile Icon)
             ┣ SizedBox (Spacing)
             ┣ Text ("John Doe")
             ┣ Text ("Flutter Developer")
             ┣ SizedBox (Spacing)
             ┣ [Reactive Section] (Conditionally renders Container or Text)
             ┣ SizedBox (Spacing)
             ┗ ElevatedButton (Toggle Button)
```

## Reactive UI Model Explained

### What is the Widget Tree?
In Flutter, everything is a widget. The UI is built by composing widgets into a tree structure. Each widget describes part of the user interface. The framework then uses this tree to construct the underlying element and render trees that actually paint pixels on the screen. 

### How does the Reactive Model work?
Flutter is reactive, meaning the UI is a function of the state. When the state of the app changes (e.g., a variable is updated), the framework rebuilds the widget tree to reflect the new state.

In this demo:
1.  We have a boolean state variable `_showDetails`.
2.  When the "Show Details" button is pressed, `setState()` is called.
3.  `setState()` notifies the framework that the internal state of this object has changed.
4.  Flutter calls the `build` method again for this `State` object.
5.  The widget tree is rebuilt with the new value of `_showDetails` (showing either the detailed text box or the prompt text).
6.  Only the parts of the UI that need to change are updated efficiently.

### Why is this efficient?
Flutter doesn't redraw the entire screen from scratch every time. Instead, it compares the old widget tree with the new one and determines the minimal set of changes required to update the underlying render tree. This makes UI updates extremely fast and smooth.

## Screenshots

| Initial State | Updated State (After Tap) |
| :---: | :---: |
| ![Initial UI](path/to/screenshot_1.png) | ![Updated UI](path/to/screenshot_2.png) |
| *Button shows "Show Details"* | *Details are visible, button shows "Hide Details"* |

*(Note: Please replace `path/to/screenshot_1.png` and `path/to/screenshot_2.png` with your actual screenshot files)*

## How to Run

To run this specific demo, use the following command:

```bash
flutter run -t lib/widget_tree_demo.dart
```

This ensures you are running the Widget Tree Demo instead of the main app entry point.
