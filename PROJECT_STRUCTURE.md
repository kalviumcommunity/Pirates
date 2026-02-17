# Flutter Project Structure

## Introduction

This document explains the default folder layout created by Flutter and the purpose of the main files and directories. Understanding this structure helps organize code, manage assets, and scale the app for teams.

## Folder & File Overview

- `lib/`: Main app source. Contains `main.dart` (entry point), UI screens, widgets, models, and services.
- `android/`: Android-specific project files (Gradle scripts, AndroidManifest, native code). Key: `android/app/build.gradle`.
- `ios/`: iOS-specific project files for Xcode. Key: `ios/Runner/Info.plist`.
- `assets/` (convention): Developer-created folder for images, fonts, JSON, etc. Declare assets in `pubspec.yaml` under `flutter:` -> `assets`.
- `test/`: Automated tests (unit, widget, integration). Default: `widget_test.dart`.
- `pubspec.yaml`: Project configuration (dependencies, assets, fonts, metadata).
- `.gitignore`: Files and folders excluded from Git commits (build outputs, secrets).
- `build/`, `.dart_tool/`, `.idea/`: Generated or IDE config folders (do not commit `build/`).

## Example `lib/` organization (recommended)

```
lib/
┣ main.dart
┣ screens/
┃ ┣ home_screen.dart
┃ ┗ login_screen.dart
┣ widgets/
┃ ┗ common_button.dart
┣ services/
┃ ┗ auth_service.dart
┗ models/
  ┗ user.dart
```

## How this structure supports scalability and teamwork

- Separation of concerns: keep UI, business logic, and data models modular and testable.
- Easier code ownership: teams can own `screens/`, `services/`, or `models/` without conflicts.
- Assets and dependencies centralized in `pubspec.yaml` for reproducible builds.
- Platform folders (`android/`, `ios/`) isolate native changes from Dart code.

## Quick checklist for new projects

- Add assets to `assets/` and declare them in `pubspec.yaml`.
- Add new features under clear subfolders in `lib/`.
- Keep platform-specific changes inside `android/` or `ios/` only.
- Add tests to `test/` as features are implemented.

## References

- See `pubspec.yaml` for dependency and asset configuration.
