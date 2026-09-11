import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skillswap/main.dart';

void main() {
  /// Pumps the app at a phone-sized viewport so the screens lay out the way
  /// they do on the emulator.
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SkillSwapApp());
  }

  /// Scrolls the current screen until [target] is on screen, the way a member
  /// scrolls down the profile form on a phone.
  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('profile screen lists the skills offered and wanted',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('My Profile'), findsOneWidget);

    await scrollTo(tester, find.text('Skills I can teach'));
    expect(find.text('Guitar'), findsOneWidget);

    await scrollTo(tester, find.text('Skills I want to learn'));
    expect(find.text('Spanish'), findsOneWidget);
  });

  testWidgets('a new skill can be added while editing',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    final field = find.widgetWithText(TextField, 'Add a skill you can teach');
    await scrollTo(tester, field);

    await tester.enterText(field, 'Ukulele');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add').first);
    await tester.pumpAndSettle();

    expect(find.text('Ukulele'), findsOneWidget);
  });

  testWidgets('confirming a slot books the session',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Booking'));
    await tester.pumpAndSettle();

    expect(find.text('Book a Session'), findsOneWidget);

    // The confirm button stays disabled until an open slot is chosen.
    final confirm = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Confirm booking'),
    );
    expect(confirm.onPressed, isNull);

    await tester.tap(find.text('9:00 AM'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm booking'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Session booked with Amelia Chen'),
      findsOneWidget,
    );
  });

  testWidgets('a slot that is already booked cannot be selected',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Booking'));
    await tester.pumpAndSettle();

    // Tuesday, the day the calendar opens on, has 10:00 AM already taken.
    await tester.tap(find.text('10:00 AM'));
    await tester.pumpAndSettle();

    expect(find.textContaining('is already booked'), findsOneWidget);
  });
}
