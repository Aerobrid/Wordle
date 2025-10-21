# Wordle Game App

A fully functional Wordle clone built with Flutter and Dart, featuring flip card animations and color-coded feedback.

## How-to-play
- 6 attempts to guess a 5-letter word
- Letter validation with color feedback:
  - **Green:** Correct letter in correct position
  - **Yellow:** Correct letter in wrong position
  - **Gray:** Letter not in word
- Smooth flip card animations
- On-screen keyboard with dynamic color updates
- Random word selection from word bank

## Getting Started

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

Check your Flutter installation:
```bash
flutter doctor
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aerobrid/Wordle.git
   cd flutter_application_wordle_1
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   **Option 1: Windows Desktop (Recommended)**
   ```bash
   flutter run -d windows
   ```

   **Option 2: Android Emulator**
   ```bash
   # Start an emulator first, then:
   flutter run
   ```

   **Option 3: Web (Chrome)**
   ```bash
   flutter run -d chrome --release
   ```
   
   > **Note:** If you encounter Chrome debugging issues in debug mode, use `--release` flag or switch to Windows/Android target.

   **Option 4: Physical Device**
   - Connect your Android/iOS device via USB
   - Enable USB debugging
   - Run: `flutter run`

### Troubleshooting

#### Chrome Debug Issues
If you see `DartDevelopmentServiceException` or Chrome connection timeout errors:

**Solution 1:** Use release mode
```bash
flutter run -d chrome --release
```

**Solution 2:** Use Windows desktop instead
```bash
flutter run -d windows
```

**Solution 3:** Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

#### No devices found
```bash
# List available devices
flutter devices

# Start an Android emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

#### Gradle build failed (Android)
```bash
cd android
./gradlew clean
cd ..
flutter run
```

## Technologies Used
- **Flutter** - UI framework
- **Dart** - Programming language
- **Equatable** - Value equality
- **FlipCard** - Tile animations

## Future Enhancements
- [ ] Statistics tracking (games played, win rate)
- [ ] Hard mode (only tell user the number of hits, misses, or in-word letters within try)
- [ ] Dark/light theme toggle
- [ ] Share results feature

## Acknowledgments
- Original Wordle game by Josh Wardle
- Flutter community for documentation
- App Code based from: [https://www.youtube.com/watch?v=_W0RN_Cqhpg&list=LL&index=13]
- Word list sourced from: [https://github.com/darkermango/5-Letter-words?tab=readme-ov-file]
