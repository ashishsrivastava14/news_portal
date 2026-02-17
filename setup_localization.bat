@echo off
echo ======================================
echo Multi-Language Setup Script
echo ======================================
echo.

echo Step 1: Running flutter pub get...
call flutter pub get
if %errorlevel% neq 0 (
    echo Error: flutter pub get failed!
    pause
    exit /b 1
)
echo.

echo Step 2: Generating localization files...
call flutter gen-l10n
echo.

echo Step 3: Checking if localization files were generated...
if exist ".dart_tool\flutter_gen\gen_l10n" (
    echo Success! Localization files have been generated.
    echo.
    echo You can now uncomment the localization code in:
    echo   - lib\main.dart
    echo   - lib\screens\user\profile_screen.dart
    echo   - lib\widgets\language_selector.dart
    echo.
    echo Look for comments like: "// Will be uncommented after generation"
) else (
    echo Localization files not found in .dart_tool\flutter_gen\gen_l10n
    echo.
    echo Trying to build the app to trigger generation...
    call flutter build apk --debug
)
echo.

echo ======================================
echo Setup Complete!
echo ======================================
echo.
echo Next steps:
echo 1. Uncomment the AppLocalizations imports and usage
echo 2. Run 'flutter run' to start the app
echo 3. Go to Profile -^> Language to change the app language
echo.
pause
