# SkillSwap

Cross-platform front end for **SkillSwap**, a peer-to-peer skill exchange app
where people trade lessons with one another instead of paying for them. Built
with Flutter for ICT725 Assessment 4, following the high-fidelity Figma
prototype produced in Assessment 3.

## What is implemented

Two screens from the prototype are implemented as working Flutter code:

| Screen | File | What it does |
| --- | --- | --- |
| Profile Creation and Skill Listing | `lib/screens/profile_screen.dart` | Captures name, email, phone and a short biography, and maintains two editable lists of skill tags (offered and wanted). Opens read-only and switches to editing, so a profile can be kept up to date. |
| Session Booking Calendar | `lib/screens/booking_screen.dart` | A day strip for the mentor's week and a grid of time slots. Open slots are green and taken slots are salmon - the colour change made after user testing - and a slot plus a session format (online or in person) is confirmed with a short success message. |

The matching feed, in-app chat and rating screens remain prototype-only, as
each depends on a backend service (recommendations, message delivery, stored
reviews) that has not been built yet.

All state is held in memory with `setState`; there is no backend or database.

## Project layout

```text
lib/
  main.dart                    app entry, theme wiring, bottom navigation
  theme/app_theme.dart         colours, text styles and shared SectionTitle
  models/user_profile.dart     profile data and the in-memory store
  models/time_slot.dart        time slots, the mentor's week, session format
  screens/profile_screen.dart  Profile Creation and Skill Listing
  screens/booking_screen.dart  Session Booking Calendar
  widgets/                     avatar bubble, star rating, skill tag editor
test/widget_test.dart          widget tests for both screens
figma_prototype/               SVG screens for the Figma prototype (see its README)
```

## Running the app

```bash
flutter pub get
flutter run
```

Start an Android emulator (Android Studio > Tools > Device Manager) before
running, or pass `-d <device>` to pick a device. `flutter devices` lists what
is available.

To check the project without a device:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

## Note for Windows and OneDrive

This project sits inside a OneDrive folder. After OneDrive syncs the generated
folders, it marks some of them read-only, and the Flutter tool then stops with
a message such as:

```text
Flutter failed to delete a directory at "...\build\unit_test_assets".
Flutter failed to delete a directory at "...\ios\Flutter\ephemeral\Packages\.packages".
```

It is a sync artefact, not a problem with the code. Clear the read-only flags
from the generated folders and run the command again:

```bat
attrib -R /S /D build\* ios\*
```

If the message names `ios\Flutter\ephemeral`, deleting that folder also works:
`rmdir /s /q ios\Flutter\ephemeral`. Flutter regenerates it on the next run.

## Design source

Colours, typography and spacing follow the improved Figma prototype from
Assessment 3. The same screens, including the ones not yet implemented, are
kept as importable SVGs in `figma_prototype/`.
