# Flutter Environment Setup and First App Run

## Project Title

Flutter Environment Setup and First Emulator Run

## System Information

OS: Windows 10/11

IDE: Android Studio / VS Code

Flutter Version: (paste from flutter --version)

Device: Android Emulator (Pixel 6)

## Setup Steps Followed

1. Flutter SDK Installation

Downloaded Flutter SDK from the official website.

Extracted to:

C:\src\flutter

Added Flutter to PATH:

C:\src\flutter\bin

Verified installation:

flutter doctor

2. Android Studio Setup

Installed Android Studio.

Installed required components:

Android SDK

SDK Platform Tools

AVD Manager

Installed plugins:

Flutter

Dart

3. Emulator Configuration

Opened AVD Manager

Created device:

Pixel 6

Android 13

Started emulator.

Verified device:

flutter devices

4. First Flutter App

Created a new project:

flutter create first_flutter_app
cd first_flutter_app
flutter run

Successfully ran the default Flutter counter app on the emulator.

## Setup Verification

Flutter Doctor Output

(Add screenshot here)

App Running on Emulator

(Add screenshot here)

## Challenges Faced

Initial PATH configuration issue for Flutter.

Android Emulator was slow during first launch.

Flutter Doctor showed missing Android licenses which were fixed using:

flutter doctor --android-licenses

## Reflection

Setting up Flutter helped me understand the complete mobile development environment including SDK configuration, emulator setup, and dependency management. This setup ensures that future Flutter and Firebase projects can be built, tested, and debugged efficiently without environment issues. It also prepares me for real-world mobile development workflows.

## What Screenshots You MUST Add

flutter doctor (all green checks)

Emulator running counter app

If any item is not green:

flutter doctor --android-licenses

## Commands Checklist (Run once)

flutter doctor

flutter doctor --android-licenses

flutter devices

flutter create first_flutter_app

cd first_flutter_app

flutter run

## PR Details

Commit message

setup: completed Flutter SDK installation and first emulator run

PR Title

[Sprint-2] Flutter Environment Setup - TeamName

## PR Description

Include:

Setup steps

Screenshots

Reflection

Video link

## 1-2 Minute Video Script (Use this)

Say:

"This is my Flutter Doctor showing a healthy setup."

"This is my Android emulator running the default Flutter app."

"Flutter SDK, Android Studio, and AVD are successfully configured."

"This environment will be used for upcoming Firebase integration tasks."

Keep it simple. Reviewers do not want a long explanation.

## Pro Tip (Important for your Sprint)

If flutter doctor shows:

Android toolchain

Install SDK from Android Studio

Chrome / Web

Ignore (not required)

## Project Structure Overview

**Project Title:** Flutter Environment Setup and First Emulator Run

I documented the default Flutter folder layout and recommended `lib/` organization in `PROJECT_STRUCTURE.md`.

- **Docs file:** [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)

### Folder summary (short)
- `lib/`: Dart code and app entry (`main.dart`).
- `android/` and `ios/`: Platform-specific build files.
- `assets/`: Static files (declare in `pubspec.yaml`).
- `test/`: Automated tests.

Add screenshots of `flutter doctor` and the emulator in the sections above when submitting your PR.

---

### Next steps for submission
1. Commit these docs with message: `docs: added Flutter project structure explanation and folder overview`.
2. Push a branch and create a PR titled: `[Sprint-2] Flutter Folder Structure Exploration – TeamName`.
3. Record a 1–2 minute video walkthrough and include the link in the PR description.

