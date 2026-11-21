import 'dart:io';

import 'package:comrade_study/data.dart';
import 'package:comrade_study/main.dart';
import 'package:comrade_study/nav.dart';
import 'package:comrade_study/store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    // Lay out with the real bundled fonts rather than the square test font.
    for (final (family, files) in [
      ('Archivo', ['Archivo.ttf']),
      ('Newsreader', ['Newsreader.ttf', 'Newsreader-Italic.ttf']),
      ('IBMPlexMono', ['IBMPlexMono-Regular.ttf', 'IBMPlexMono-Medium.ttf']),
    ]) {
      final loader = FontLoader(family);
      for (final file in files) {
        final bytes = File('assets/fonts/$file').readAsBytesSync();
        loader.addFont(Future.value(ByteData.view(bytes.buffer)));
      }
      await loader.load();
    }
    await Course.load();
    await store.load();
  });

  test('bundled course data is complete', () {
    expect(course.lessons.length, 18);
    expect(course.modules.length, 6);
    expect(course.sourceParts.length, 4);
    expect(course.passageCount, 64);
    expect(course.quizCount, 36);
    expect(course.glossaryTerms.length, 46);
    // Sections are numbered 1..64 in order, with no URL (the book is in copyright).
    expect([for (final p in course.allPassages) p.page], List.generate(64, (i) => i + 1));
    expect(course.allPassages.every((p) => p.url.isEmpty), isTrue);
    for (final lesson in course.lessons) {
      expect(RegExp(r'§§?\d+').hasMatch(lesson.eyebrow), isTrue, reason: lesson.id);
    }
    for (final term in course.glossaryTerms) {
      expect(course.lesson(term.lessonId), isNotNull, reason: term.term);
    }
  });

  testWidgets('every tab and a full lesson flow render on a phone', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 760 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ComradeStudyApp());
    expect(find.text('Begin with lesson 01'), findsOneWidget);

    for (final tab in [1, 2, 3, 4]) {
      AppNav.tab.value = tab;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'tab $tab');
    }
    for (final lab in ['scale', 'relations', 'discipline']) {
      AppNav.lab.value = lab;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'lab $lab');
    }

    // Open lesson 1, answer both questions correctly, save a note.
    AppNav.tab.value = AppNav.curriculum;
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('A joke and a room'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('A joke and a room'));
    await tester.pumpAndSettle();
    final lesson = course.lessons.first;
    for (final q in lesson.quiz) {
      final option = find.text(q.options[q.answer]);
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
      await tester.tap(option);
      await tester.pump();
      final check = find.text('Check answer');
      await tester.ensureVisible(check);
      await tester.tap(check);
      await tester.pumpAndSettle();
      expect(find.text('Correct.'), findsOneWidget);
      final next = find.textContaining(RegExp('Next question|Finish check'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
    }
    expect(store.entry(lesson.id).completed, isTrue);
    expect(store.entry(lesson.id).bestScore, 100);

    // The lesson's reading tracker lists the book sections in its eyebrow.
    expect(find.textContaining('I have read §1 ·'), findsOneWidget);
    expect(find.textContaining('I have read §2 ·'), findsOneWidget);

    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'What does a wage pay for?');
    await tester.pump();
    await tester.ensureVisible(find.text('Save note'));
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(store.note(lesson.id), 'What does a wage pay for?');

    // The reading tracker marks passages and persists them.
    final passage = course.sourceParts.first.passages.first;
    store.setRead(passage, true);

    // Progress survives a restart.
    final reloaded = LearningStore();
    await reloaded.load();
    expect(reloaded.entry(lesson.id).completed, isTrue);
    expect(reloaded.note(lesson.id), 'What does a wage pay for?');
    expect(reloaded.isRead(passage), isTrue);

    // The library renders with a passage ticked.
    Navigator.of(tester.element(find.byType(TextField))).pop();
    await tester.pumpAndSettle();
    AppNav.tab.value = AppNav.library;
    await tester.pumpAndSettle();
    expect(find.text('1/${course.passageCount}'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Tapping a section row (no URL) toggles it read.
    final second = course.sourceParts.first.passages[1];
    final row = find.text(second.title);
    final listEl = find.ancestor(of: find.text('1/${course.passageCount}'), matching: find.byType(Scrollable)).evaluate().first;
    final list = find.byElementPredicate((e) => identical(e, listEl));
    await tester.scrollUntilVisible(row, 300, scrollable: list);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(store.isRead(second), isTrue);
    expect(store.readCount(course.allPassages), 2);
  });

  testWidgets('every lesson and lab renders on a small phone', (tester) async {
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    AppNav.tab.value = AppNav.home;
    await tester.pumpWidget(const ComradeStudyApp());
    // Home, including every step of the concept player.
    final homeEl = find.ancestor(of: find.text('Explore all ${course.lessons.length} lessons'), matching: find.byType(Scrollable)).evaluate().first;
    await tester.scrollUntilVisible(find.text('Next move'), 300, scrollable: find.byElementPredicate((e) => identical(e, homeEl)));
    await tester.pumpAndSettle();
    for (var i = 0; i < 5; i++) {
      final next = find.text('Next move');
      await tester.ensureVisible(next);
      await tester.pumpAndSettle();
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'home move $i');
    }
    for (final lab in ['accountability', 'scale', 'relations', 'discipline']) {
      AppNav.tab.value = AppNav.labs;
      AppNav.lab.value = lab;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'lab $lab');
    }
    // Every relation in the relations lab.
    AppNav.lab.value = 'relations';
    await tester.pumpAndSettle();
    for (final name in ['Kin', 'Neighbor', 'Citizen', 'Friend', 'Comrade']) {
      final chip = find.text(name).first;
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'relation $name');
    }
    for (final lesson in course.lessons) {
      AppNav.openLesson(tester.element(find.byType(NavigationBar)), lesson.id);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(SingleChildScrollView).last, const Offset(0, -20000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: lesson.id);
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();
    }
  });
}
