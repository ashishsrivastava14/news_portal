# Multi-Language Setup Checklist

Follow these steps in order to complete the multi-language setup:

## ☐ Step 1: Uncomment Imports

### File: `lib/main.dart`
- [ ] Line ~11: Uncomment `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`
- [ ] Line ~64: Uncomment `AppLocalizations.delegate,` in localizationsDelegates list

### File: `lib/screens/user/profile_screen.dart`
- [ ] Line ~8: Uncomment `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`
- [ ] Line ~19: Uncomment `final l10n = AppLocalizations.of(context)!;`
- [ ] Line ~131: Change `'Language'` to `l10n.language`

### File: `lib/widgets/language_selector.dart`
- [ ] Line ~3: Uncomment `import 'package:flutter_gen/gen_l10n/app_localizations.dart';`
- [ ] Line ~12: Uncomment `final l10n = AppLocalizations.of(context)!;`
- [ ] Line ~15: Change `const Text('Select Language')` to `Text(l10n.selectLanguage)`
- [ ] Line ~48: Change `const Text('Cancel')` to `Text(l10n.cancel)`
- [ ] Line ~60: Uncomment `final l10n = AppLocalizations.of(context)!;`
- [ ] Line ~64: Change `const Text('Language')` to `Text(l10n.language)`

## ☐ Step 2: Generate Localization Files

Run one of these commands:
```bash
flutter gen-l10n
# OR
flutter run
# OR
flutter build apk
```

## ☐ Step 3: Verify

- [ ] App compiles without errors
- [ ] Navigate to Profile → Language
- [ ] Try switching languages
- [ ] Verify language persists after app restart

## ✅ Done!

Your app now supports English, Hindi, Tamil, and Telugu!

---

**Tip:** You can use the search function (Ctrl+F) to quickly find the commented lines in each file.
