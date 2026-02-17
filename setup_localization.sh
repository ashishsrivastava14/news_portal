#!/bin/bash

echo "======================================"
echo "Multi-Language Setup Script"
echo "======================================"
echo ""

echo "Step 1: Running flutter pub get..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Error: flutter pub get failed!"
    exit 1
fi
echo ""

echo "Step 2: Generating localization files..."
flutter gen-l10n
echo ""

echo "Step 3: Checking if localization files were generated..."
if [ -d ".dart_tool/flutter_gen/gen_l10n" ]; then
    echo "Success! Localization files have been generated."
    echo ""
    echo "You can now uncomment the localization code in:"
    echo "  - lib/main.dart"
    echo "  - lib/screens/user/profile_screen.dart"
    echo "  - lib/widgets/language_selector.dart"
    echo ""
    echo 'Look for comments like: "// Will be uncommented after generation"'
else
    echo "Localization files not found in .dart_tool/flutter_gen/gen_l10n"
    echo ""
    echo "Trying to build the app to trigger generation..."
    flutter build apk --debug
fi
echo ""

echo "======================================"
echo "Setup Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Uncomment the AppLocalizations imports and usage"
echo "2. Run 'flutter run' to start the app"
echo "3. Go to Profile -> Language to change the app language"
echo ""
