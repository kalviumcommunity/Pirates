# Working with Assets & Icons

This demo app demonstrates how to manage static assets (images, icons) in Flutter, including folder organization, pubspec.yaml configuration, and displaying both local images and Flutter's built-in icon library.

## Concept Overview

### What are Assets?
Assets are static files packaged with your Flutter app. They include:

- **Images:** PNG, JPG, SVG, or GIF files
- **Icons:** Built-in Flutter icons or custom SVG icons
- **Fonts & JSON:** For styling and data configuration

Assets are referenced through `pubspec.yaml` so Flutter includes them during the build process.

## Asset Organization

### Folder Structure
Keep your assets organized in a clear directory structure:

```
assets/
 ├── images/
 │    ├── logo.svg
 │    ├── banner.svg
 │    └── background.png
 └── icons/
      ├── star.svg
      └── profile.svg
```

## Configuration Steps

### Step 1: Create Asset Folders
Create new directories under the project root:

```bash
mkdir -p assets/images
mkdir -p assets/icons
```

### Step 2: Register Assets in pubspec.yaml
Update the `flutter:` section in `pubspec.yaml` with proper indentation (2 spaces):

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

**Important:** YAML requires exact 2-space indentation. Incorrect spacing causes build errors.

## Using Images in Flutter

### Option 1: Image.asset() Widget
Display local image files:

```dart
Image.asset(
  'assets/images/logo.svg',
  width: 150,
  height: 150,
  fit: BoxFit.cover,
)
```

**Key Parameters:**
- `width` / `height` – Set image dimensions
- `fit` – Controls how image scales (contain, cover, fill, etc.)

### Option 2: Background Image Container
Use images as decorative backgrounds:

```dart
Container(
  width: 300,
  height: 150,
  decoration: BoxDecoration(
    color: Colors.teal.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.teal, width: 2),
  ),
  child: const Center(
    child: Text('Content over background'),
  ),
);
```

## Flutter's Built-in Icon Library

### Material Design Icons
Access thousands of Material Design icons instantly:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.star, color: Colors.amber, size: 48),
    SizedBox(width: 10),
    Icon(Icons.favorite, color: Colors.red, size: 48),
    SizedBox(width: 10),
    Icon(Icons.thumb_up, color: Colors.green, size: 48),
  ],
)
```

**Common Icons:**
- `Icons.star` – Star icon
- `Icons.favorite` – Heart icon
- `Icons.settings` – Gear icon
- `Icons.logout` – Logout icon
- `Icons.notifications` – Bell icon

### Platform-Specific Icons
Switch between Material and Cupertino (iOS-style) icons:

```dart
// Material icons
Icon(Icons.android, color: Colors.green, size: 48);
Icon(Icons.apple, color: Colors.grey, size: 48);

// Cupertino (iOS-style) icons
import 'package:flutter/cupertino.dart';
Icon(CupertinoIcons.heart, color: Colors.pink, size: 48);
```

## Complete Example

The [AssetDemoScreen](lib/screens/asset_demo_screen.dart) demonstrates:

- Local image asset display (`Image.asset()`)
- Material Design icons in a grid
- Platform-specific icons (Android, iOS, Cupertino)
- Icon layouts with labels
- Responsive icon sizing

## Project Structure

After setup, your project tree includes:

```
lib/
  screens/
    asset_demo_screen.dart
assets/
  images/
    logo.svg
    banner.svg
  icons/
    star.svg
```

## Troubleshooting Asset Issues

| Issue | Solution |
| --- | --- |
| **Incorrect paths** | Ensure code paths match folder structure exactly |
| **YAML indentation errors** | Use exactly 2 spaces for each nested level |
| **Asset not loading** | Verify folder is listed under `flutter: assets:` |
| **Hot reload doesn't update** | Run `flutter pub get` after adding new assets |
| **Red "missing asset" boxes** | Check build console for typos in asset paths |

## Reflection

### How do assets improve app functionality?
Assets enable you to brand your app with custom logos, display contextual images, and use consistent icons. They transform plain text interfaces into visually rich, professional applications.

### Why is organizing assets important for scalability?
Clear asset organization (images/, icons/) makes it easy to locate resources, reduces duplication, and simplifies maintenance. As the asset library grows, good structure prevents chaos and speeds up development.

### What challenges appeared when managing assets?
Common challenges include:
- Path mismatches between code and folder structure
- YAML formatting errors causing silent failures
- Forgetting to run `flutter pub get` after adding assets
- Mixing asset types in a single folder, reducing clarity

## How to Run

To run the assets demo screen:

```bash
flutter run -t lib/screens/asset_demo_screen.dart
```

## Screenshots

| Local Images | Built-in Icons |
| :---: | :---: |
| ![Logo & Banner](path/to/assets_images.png) | ![Icon Grid](path/to/assets_icons.png) |
| *Logo and banner displayed with Image.asset()* | *Material Design icons in responsive grid* |

---

# Previous Lesson: Responsive Design with MediaQuery and LayoutBuilder

This demo app demonstrates how to create adaptive UIs that work seamlessly across different device sizes and orientations using `MediaQuery` and `LayoutBuilder`.

## Concept Overview

### What is Responsive Design?
Responsive design allows your Flutter app to adapt to any device size or orientation by using flexible layout rules instead of fixed pixel dimensions. This ensures smooth scaling on phones, tablets, and future devices.

**Benefits:**
- Prevents UI clipping and overflow issues
- Ensures consistent experience across devices
- Makes apps future-ready for tablets and foldables
- Improves user experience with proportional scaling

## Key Concepts & Code Snippets

### 1. MediaQuery for Screen Dimensions
`MediaQuery` provides real-time information about screen size, orientation, and device padding.

```dart
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

Container(
  width: screenWidth * 0.8,  // 80% of screen width
  height: screenHeight * 0.1, // 10% of screen height
  color: Colors.teal,
  child: const Center(child: Text('Responsive Container')),
);
```

**Key Methods:**
- `MediaQuery.of(context).size.width` – Get screen width
- `MediaQuery.of(context).size.height` – Get screen height
- `MediaQuery.of(context).orientation` – Check portrait/landscape

### 2. LayoutBuilder for Conditional Layouts
`LayoutBuilder` helps define different UI structures based on available screen space. It provides layout constraints to switch between mobile and tablet designs.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      // Mobile Layout: Vertical stacking
      return Column(
        children: [
          Text('Mobile Layout'),
          Icon(Icons.phone_android, size: 80),
        ],
      );
    } else {
      // Tablet Layout: Horizontal arrangement
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tablet Layout'),
          SizedBox(width: 20),
          Icon(Icons.tablet, size: 100),
        ],
      );
    }
  },
);
```

### 3. Combining Both for Advanced Responsiveness
Use `MediaQuery` for proportional sizing and `LayoutBuilder` for structural adaptation.

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = constraints.maxWidth < 600;

    return isMobile
        ? Column(
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.12,
                color: Colors.tealAccent,
                child: const Center(child: Text('Mobile View')),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.15,
                color: Colors.orangeAccent,
                child: const Center(child: Text('Tablet Left')),
              ),
              Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.15,
                color: Colors.lightBlueAccent,
                child: const Center(child: Text('Tablet Right')),
              ),
            ],
          );
  },
);
```

## Implementation Details

The [ResponsiveDesignDemo](lib/screens/responsive_design_demo.dart) screen demonstrates:

- **Proportional Sizing:** Containers use percentage-based dimensions
- **Layout Switching:** Column for mobile, Row for tablet
- **Dynamic Typography:** Font sizes scale based on device type
- **Screen Info Display:** Real-time display of device dimensions and layout type

## Screenshots

| Mobile View (Portrait) | Tablet View (Landscape) |
| :---: | :---: |
| ![Mobile Layout](path/to/mobile_responsive.png) | ![Tablet Layout](path/to/tablet_responsive.png) |
| *Column layout with 80% width* | *Row layout with dual panels* |

## Reflection

### How do these tools make your UI more adaptive?
`MediaQuery` provides real-time device dimensions for proportional sizing, while `LayoutBuilder` enables structural changes based on available space. Together, they ensure your UI scales gracefully and reorganizes logically across all device sizes.

### Why is responsive design crucial for real-world Flutter apps?
Modern apps must support diverse devices: phones, tablets, foldables, and desktops. Responsive design eliminates the need to maintain separate UIs for different screen sizes and provides a seamless user experience regardless of device.

### What challenges did you face when testing across different screen sizes?
Common challenges include:
- Ensuring text doesn't overflow on small screens
- Maintaining consistent spacing across devices
- Managing adaptive layouts without performance degradation
- Testing breakpoints (e.g., when to switch from mobile to tablet layout)

## How to Run

To run the responsive design demo:

```bash
flutter run -t lib/screens/responsive_design_demo.dart
```

---

# Previous Lesson: Reusable Custom Widgets

This demo app showcases how to build and reuse custom widgets across multiple screens to improve code organization and maintain design consistency.

## Concept Overview

### What are Custom Widgets?
Custom widgets are classes that combine existing Flutter widgets to create reusable UI components. They can be stateless (immutable) or stateful (dynamic).

**Stateless Custom Widget:** Best for static layouts that don't change after being built (e.g., `InfoCard`).

**Stateful Custom Widget:** Best for widgets that change based on user interaction (e.g., `LikeButton`).

## Custom Widgets Created

### 1. InfoCard (Stateless)
A reusable card widget that displays an icon, title, and subtitle.

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
```

**Usage Example (HomeScreen):**

```dart
InfoCard(
  title: 'Add New Note',
  subtitle: 'Create and manage your notes',
  icon: Icons.note_add,
)
```

### 2. LikeButton (Stateful)
A reusable interactive button that toggles between liked and unliked states.

```dart
class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
        });
      },
    );
  }
}
```

**Usage Example (Multiple Screens):**

```dart
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () => _handleAddNote(user.uid),
        child: const Text('Add Note'),
      ),
    ),
    const SizedBox(width: 8),
    const LikeButton(),
  ],
)
```

## Reusability Across Screens

The same custom widgets are imported and used in multiple screens:

- [HomeScreen](lib/screens/home_screen.dart) – Uses `InfoCard` and `LikeButton`
- [ReusableWidgetsDemo](lib/screens/reusable_widgets_demo.dart) – Showcases both widgets in a list

This keeps the design consistent and eliminates duplicate code.

## Screenshots

| InfoCard Examples | LikeButton Interaction |
| :---: | :---: |
| ![InfoCard Display](path/to/infocard_screen.png) | ![LikeButton Toggle](path/to/likebutton_screen.png) |
| *Same widget, different data* | *Stateful widget reused multiple times* |

## Reflection

### How do reusable widgets improve code organization?
Custom widgets encapsulate UI logic and styling, reducing repetition. Changes to widget design only need to be made in one place, improving maintainability and consistency across screens.

### Why is modularity important in team-based development?
Modular widgets allow team members to work independently on different features without conflicts. Clear widget contracts (props/parameters) make integration seamless and reduce integration issues.

### What challenges did you face while refactoring into widgets?
Common challenges include identifying the right level of abstraction, deciding which props to expose, and understanding when to use stateless vs stateful widgets. Testing reusability across different contexts helps validate widget design.

## How to Run

To run the reusable widgets demo:

```bash
flutter run -t lib/screens/reusable_widgets_demo.dart
```

---

# Previous Lesson: State Management with setState

This demo app shows how local state changes with `setState()` in a `StatefulWidget`. It includes a counter with increment/decrement actions and a conditional background color when the count reaches a threshold.

## Concept Overview

### Stateless Widgets
A `StatelessWidget` does not hold internal state. It renders from its inputs and does not change unless its parent rebuilds.

### Stateful Widgets
A `StatefulWidget` holds mutable state in a `State` object. Calling `setState()` triggers a rebuild for that widget subtree.

## setState Snippets

**Local state update**

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

**Conditional UI based on state**

```dart
final Color backgroundColor =
    _counter >= 5 ? Colors.greenAccent : Colors.white;
```

## Screenshots

| Initial State | Updated State (After Interaction) |
| :---: | :---: |
| ![Initial UI](path/to/initial_state.png) | ![Updated UI](path/to/updated_state.png) |
| *Counter starts at 0* | *Counter increments and background changes at 5* |

## Reflection

### What is the difference between Stateless and Stateful widgets?
Stateless widgets are immutable and render only from inputs. Stateful widgets store mutable data and can rebuild their UI when state changes.

### Why is setState important for Flutter's reactive model?
`setState()` notifies Flutter that the state has changed so it can rebuild the affected widget subtree and keep the UI in sync with data.

### How can improper use of setState affect performance?
Calling `setState()` too often or on large widgets can cause unnecessary rebuilds and reduce frame performance.

## How to Run

To run this specific demo, use the following command:

```bash
flutter run -t lib/screens/state_management_demo.dart
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

---

## Responsive Layout Using Rows, Columns & Containers

A new screen (`ResponsiveLayout`) demonstrates combining `Row`, `Column`, and
`Container` widgets along with `MediaQuery` to adapt to various screen widths.
The layout stack is:

```
Scaffold
 ┣ AppBar
 ┗ Body (Container)
    ┗ Column
       ┣ Header (Container)
       ┣ Expanded
       ┃ ┗ Row or Column (depending on width)
       ┃   ┣ Left Panel
       ┃   ┗ Right Panel
       ┗ Footer (shown on narrow screens)
```

The main route (`/responsive`) is linked from the login screen via a button.
On wide screens (>600px) the panels sit side‑by‑side; on narrow phones they
stack vertically. MediaQuery is used to compute `screenWidth` and conditionally
switch between `Row` and `Column` layouts.

### Key code snippet

```dart
final screenWidth = MediaQuery.of(context).size.width;
final bool isWide = screenWidth > 600;

Expanded(
  child: isWide
      ? Row(...)
      : Column(...),
),
```

### Screenshots (placeholders)

- Wide/tablet view (`docs/responsive_tablet.png`)
- Narrow/phone view (`docs/responsive_phone.png`)

### Reflection

* Responsive design ensures a consistent experience on phones and tablets. It
  prevents overflow errors and makes the UI feel native to each form factor.
* Challenges included managing spacing when switching between horizontal and
  vertical layouts; `Expanded` and `SizedBox` were instrumental for balance.
* `MediaQuery` combined with `Expanded` allows layouts to reflow without manual
  width calculations, making the UI flexible as new panels are added.

---

## Scrollable Views with ListView & GridView

A new screen (`ScrollableViews`) showcases a horizontally scrolling list and a
fixed grid, using `ListView.builder` and `GridView.builder` inside a
`SingleChildScrollView` so both components can appear on the same page. The
route `/scrollable` is reachable from the login screen.

### Code snippets

**Horizontal `ListView.builder`**
```dart
SizedBox(
  height: 200,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 20,
    itemBuilder: (context, index) {
      return Container(
        width: 150,
        margin: const EdgeInsets.all(8),
        color: Colors.teal[100 * ((index % 8) + 2)],
        child: Center(child: Text('Card $index')),
      );
    },
  ),
),
```

**Vertical `GridView.builder`**
```dart
SizedBox(
  height: 400,
  child: GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: 20,
    itemBuilder: (context, index) {
      return Container(
        color: Colors.primaries[index % Colors.primaries.length],
        child: Center(
          child: Text('Tile $index',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    },
  ),
),
```

### Screenshots

- Horizontal list scrolling: `docs/scroll_list.png`
- Grid view in same screen: `docs/scroll_grid.png`

### Reflection

* Flutter lazily builds list/grid items only when they come into view, which
  keeps memory usage low for large datasets. This is why `ListView.builder`
  and `GridView.builder` are preferred for dynamic content.
* The `builder` constructors reuse widgets and avoid inflating an entire list
  upfront, which dramatically improves performance.
* Grid layouts improve aesthetics by presenting items in a structured matrix,
  ideal for galleries or catalogs.

---

## User Input Form & Validation

A new screen (`UserInputForm`) provides two text fields for name and email and
validates the entries when the user taps *Submit*. It demonstrates basic form
handling, validators, and feedback using a `SnackBar`. Navigate via the login
screen button labelled *User input form demo*.

### Code snippet

```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Name'),
        validator: (value) =>
            value == null || value.isEmpty ? 'Enter your name' : null,
      ),
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter your email';
          if (!value.contains('@')) return 'Enter a valid email';
          return null;
        },
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form submitted successfully!')),
            );
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
);
```

### Screenshots

- Validation errors when fields are empty: `docs/form_error.png`
- Successful submission message: `docs/form_success.png`

### Reflection

* Input validation prevents bad data and improves user trust. Immediate
  feedback keeps users informed about what’s required.
* `FormState` centralizes validation and simplifies checking multiple fields
  with a single call to `validate()`.
* `SnackBar` provides non‑intrusive feedback; other options include dialogs or
  inline messages depending on the app’s style.


