# Comrade Study

An offline Android and iOS course for reading Jodi Dean’s *Comrade: An Essay on
Political Belonging* (Verso, 2019): guided lessons, knowledge checks,
interactive models, flashcards, notes, bookmarks, a section-by-section reading
tracker, and progress tracking. Built with Flutter, as a sibling of the Capital
Study and Grundrisse Study apps.

## Download

### Android

**[⬇ Download comrade-study.apk](https://github.com/MechanicalMindVonMisses/comrade-study-app/releases/latest/download/comrade-study.apk)** (about 49 MB, Android 7.0 or newer)

1. Open the link above on your Android phone and download the file.
2. Tap the downloaded file. If Android asks, allow your browser or file manager to install unknown apps.
3. Tap **Install**, then open **Comrade Study**.

The APK is not from the Play Store, so Android shows its standard warning for sideloaded apps.

### iPhone and iPad

**[⬇ Download comrade-study.ipa](https://github.com/MechanicalMindVonMisses/comrade-study-app/releases/latest/download/comrade-study.ipa)** (iOS 15 or newer)

The app is not on the App Store. The `.ipa` is unsigned, so it is installed
with a sideloading tool that signs it with your own Apple ID:

1. Install [AltStore](https://altstore.io) or [Sideloadly](https://sideloadly.io) on a Mac or PC and connect your iPhone.
2. Download the `.ipa` above and open it with AltStore (*My Apps → +*) or drag it into Sideloadly.
3. Sign in with your Apple ID when asked. On the phone, trust the developer under *Settings → General → VPN & Device Management*.

With a free Apple ID the install lasts 7 days; AltStore refreshes it
automatically while it is running.

All releases are listed on the [Releases page](https://github.com/MechanicalMindVonMisses/comrade-study-app/releases).

Companion apps: [Capital Study](https://github.com/MechanicalMindVonMisses/capital-study-app) and [Grundrisse Study](https://github.com/MechanicalMindVonMisses/grundrisse-study).

## What is included

- 18 lessons across six levels: the comrade as a relation; survivors, systems
  and the critique of allyship; the generic comrade (women and black
  communists, the Black Belt thesis); Platonov’s comrades and the first two
  theses; generic-not-unique, the individual as Other, and fidelity to a truth;
  discipline, joy, enthusiasm and courage, the ways comradeship ends, and a
  critical-reading lesson.
- Two-question knowledge checks for every lesson, with explanations and saved best scores.
- Four interactive labs: who shows up (allies vs comrades), survivors, systems
  and the organized many, five relations (kin, neighbor, citizen, friend,
  comrade), and discipline and its superegoic excess.
- A searchable 46-term glossary and flashcard review mode.
- A reading room splitting the book into 64 numbered study sections across its
  four chapters, with an on-device “read” tracker and free companion texts.
- Lesson notes, bookmarks, a notebook, and previous/next navigation.

Lesson text is original study material. It distinguishes what Dean argues,
what her sources show, and what critics say. The labs are simplified teaching
models, not predictions.

## Offline use and your data

Everything above is bundled in the app and works without a connection. There
is no account and no server: progress, scores, bookmarks, notes and read
sections are stored only on the device.

*Comrade* is in copyright, so the app contains none of its text: read along in
your own copy. The e-book has no printed page numbers, so sections (§) are the
app’s own study divisions following the book’s chapters and sub-headings.
Companion links (Dean’s free e-flux essay “Four Theses on the Comrade”, Mark
Fisher, Kollontai, Lenin, Haywood, Marx and others on marxists.org) open in the
browser and need a connection.

## Building from source

Requires the Flutter SDK, plus the Android SDK for Android or Xcode (on a Mac) for iOS.

```bash
python tool/build_course.py   # regenerate assets/data/course.json after editing tool/content_*.py
flutter pub get
flutter test
flutter build apk --release                  # Android
flutter build ios --release --no-codesign    # iOS (macOS only)
```

The APK lands in `build/app/outputs/flutter-apk/app-release.apk`, signed with
the debug key (fine for sideloading; set up a release keystore before
publishing to Play).

iOS builds need Xcode, so they run on GitHub Actions
(`.github/workflows/ios.yml`): pushing a `v*` tag builds the unsigned
`comrade-study.ipa` on a macOS runner and attaches it to that release. The
workflow can also be started by hand from the Actions tab. To ship through the
App Store or TestFlight, open `ios/Runner.xcworkspace` in Xcode and set a
signing team. `python tool/make_ios_icon.py` regenerates the iOS app icons.

## Layout

- `tool/content_*.py` — lessons, glossary and the reading-room index; `tool/build_course.py` validates and writes the JSON
- `assets/data/course.json` — generated course content
- `assets/fonts/` — Archivo, Newsreader, IBM Plex Mono (SIL OFL)
- `lib/data.dart` — models and loader
- `lib/store.dart` — on-device progress, bookmarks, notes, read sections
- `lib/theme.dart` — palette, type, shared widgets
- `lib/screens/` — home, curriculum, lesson, library, labs, glossary, notebook
- `android/`, `ios/` — platform projects
