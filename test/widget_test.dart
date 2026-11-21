import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/data/sample_entries.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/widgets/mood_card.dart';

/// Renders the app in a window tall enough for every card to be built.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MoodTrackerApp());
}

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');

Future<void> selectScore(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(ChoiceChip, '3'));
  await tester.pump();
}

void main() {
  testWidgets('saving without a score shows an error and adds no entry', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('a 2001-character note shows an error and adds no entry', (
    tester,
  ) async {
    await pumpApp(tester);
    await selectScore(tester);
    await tester.enterText(find.byType(TextField), 'a' * 2001);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Notes may be at most 2000 characters'), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('a 2000-character note is saved and resets the form', (
    tester,
  ) async {
    final note = 'a' * 2000;
    await pumpApp(tester);

    await selectScore(tester);
    await tester.enterText(find.byType(TextField), note);
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text(note),
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '3')).selected,
      isFalse,
    );
  });

  testWidgets('correcting an overlong note clears the error and saves', (
    tester,
  ) async {
    await pumpApp(tester);

    await selectScore(tester);
    await tester.enterText(find.byType(TextField), 'a' * 2001);
    await tester.tap(saveButton);
    await tester.pump();
    expect(find.text('Notes may be at most 2000 characters'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Rainy walk home');
    await tester.pump();
    expect(find.text('Notes may be at most 2000 characters'), findsNothing);
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('Rainy walk home'),
      ),
      findsOneWidget,
    );
    expect(find.text('Notes may be at most 2000 characters'), findsNothing);
  });

  testWidgets('saving with no note stores only the score', (tester) async {
    await pumpApp(tester);

    await selectScore(tester);
    await tester.tap(saveButton);
    await tester.pump();

    final entry = tester.widget<MoodCard>(find.byType(MoodCard).first).entry;
    expect(entry.score, 3);
    expect(entry.note, isNull);
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('No note'),
      ),
      findsOneWidget,
    );
  });
}
