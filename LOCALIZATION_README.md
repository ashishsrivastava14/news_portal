# Multi-Language Support Setup

This News Portal app now supports multiple languages including:
- English (en)
- Hindi (hi) - हिंदी
- Tamil (ta) - தமிழ்
- Telugu (te) - తెలుగు

## Setup Instructions

### 1. Generate Localization Files

The localization files need to be generated before the app can run. Run one of these commands:

```bash
# Generate localization files
flutter gen-l10n

# OR run the app (which will automatically generate them)
flutter run

# OR build the app
flutter build apk
```

### 2. Files Created

The following files have been added to support multi-language:

#### Configuration Files:
- `l10n.yaml` - Localization configuration
- `lib/l10n/app_en.arb` - English translations  
- `lib/l10n/app_hi.arb` - Hindi translations
- `lib/l10n/app_ta.arb` - Tamil translations
- `lib/l10n/app_te.arb` - Telugu translations

#### Code Files:
- `lib/providers/language_provider.dart` - Language state management
- `lib/widgets/language_selector.dart` - Language selection UI

#### Modified Files:
- `pubspec.yaml` - Added flutter_localizations dependency
- `lib/main.dart` - Added localization delegates and language provider
- `lib/screens/user/profile_screen.dart` - Added language selector

### 3. Using Localizations in Your Code

To use localized strings in your widgets:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.home); // Will show "Home", "होम", "முகப்பு", or "హోమ్" based on selected language
  }
}
```

### 4. Available Localized Strings

Here are some of the available localized strings:

**Navigation:**
- `l10n.home`
- `l10n.categories`
- `l10n.bookmarks`
- `l10n.profile`
- `l10n.search`

**News:**
- `l10n.breakingNews`
- `l10n.latestNews`
- `l10n.topStories`
- `l10n.trending`

**Actions:**
- `l10n.readMore`
- `l10n.share`
- `l10n.bookmark`
- `l10n.login`
- `l10n.logout`

**Settings:**
- `l10n.settings`
- `l10n.language`
- `l10n.theme`
- `l10n.darkMode`
- `l10n.notifications`

**Common:**
- `l10n.save`
- `l10n.cancel`
- `l10n.delete`
- `l10n.edit`
- `l10n.yes`
- `l10n.no`

See `lib/l10n/app_en.arb` for the complete list of available strings.

### 5. Adding New Languages

To add support for more languages:

1. Create a new ARB file in `lib/l10n/` (e.g., `app_mr.arb` for Marathi)
2. Copy the content from `app_en.arb`
3. Translate all values to the new language
4. Update `lib/providers/language_provider.dart`:
   ```dart
   static const List<Locale> supportedLocales = [
     Locale('en'),
     Locale('hi'),
     Locale('ta'),
     Locale('te'),
     Locale('mr'), // Add new language
   ];
   
   static const Map<String, String> languageNames = {
     'en': 'English',
     'hi': 'हिंदी',
     'ta': 'தமிழ்',
     'te': 'తెలుగు',
     'mr': 'मराठी', // Add new language name
   };
   ```
5. Run `flutter gen-l10n` to regenerate localization files

### 6. Changing Language

Users can change the app language from:
1. Profile Screen → Language option
2. The language selector dialog will appear
3. Select desired language
4. The app will immediately update to show content in the selected language

The selected language is persisted using SharedPreferences and will be remembered across app restarts.

### 7. Adding New Strings

To add new localized strings:

1. Add the key-value pair to ALL ARB files:
   
   In `app_en.arb`:
   ```json
   {
     "myNewString": "My New String"
   }
   ```
   
   In `app_hi.arb`:
   ```json
   {
     "myNewString": "मेरी नई स्ट्रिंग"
   }
   ```
   
   And so on for Tamil and Telugu...

2. Run `flutter gen-l10n` to regenerate

3. Use in code:
   ```dart
   Text(l10n.myNewString)
   ```

### 8. Troubleshooting

**Error: Target of URI doesn't exist: 'package:flutter_gen/gen_l10n/app_localizations.dart'**

Solution: Run `flutter gen-l10n` or `flutter run` to generate the localization files.

**Changes to ARB files not reflected**

Solution: Run `flutter clean` then `flutter pub get` then `flutter gen-l10n`

**Build errors after adding new language**

Solution: Make sure the new language is added to both `supportedLocales` and `languageNames` in `language_provider.dart`

## Notes

- The generated localization files are stored in `.dart_tool/flutter_gen/gen_l10n/` (gitignored)
- Always run `flutter gen-l10n` after modifying ARB files
- The app uses  Right-to-Left (RTL) support for languages like Arabic/Urdu if you add them in future
