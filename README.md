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

## Featured Updates
- ✅ Hard mode (Toggle to hide tile colors and only show color counts)
- ✅ Keyboard Support
- ✅ Additional Word list for proper 5-letter word comprehension at runtime

## Getting Started

### 🐳 Quick Start with Docker (Recommended - No Flutter Required!)
> Do however make sure you have **Docker-Desktop (which usually contains Docker-Compose)** installed and **running** before running wordle game with Docker Linux container on port 8080

The easiest way to run the app without installing Flutter or any dependencies:

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aerobrid/Wordle.git
   cd flutter_application_wordle_1
   ```

2. **Run with Docker Compose** (easiest):
   ```bash
   docker-compose up --build
   ```
   Then open **http://localhost:8080** in your browser.

3. **Or build and run manually**:
   ```bash
   # Build the Docker image
   docker build -t wordle-app .
   
   # Run the container
   docker run -d -p 8080:80 --name wordle wordle-app
   ```
   Then open **http://localhost:8080** in your browser.

4. **Change Host Port (Optional)** \
   You can run the container on a different host port without editing the ```docker-compose.yml```:
   ```bash
   # Example: run on port 3000 instead of 8080
   docker run -d -p 3000:80 --name wordle wordle-app
   ```
   Then you can open **http://localhost:3000** or whatever port suitable on your browser. \
   With Docker Compose, you can use an **environment variable:** \
   \
      **1.** Edit ```docker-compose.yml``` ports section: 
      ```bash
      ports:
      - "${PORT:-8080}:80"
      ```

      **2.** Run Compose with a custom port: 
      ```bash
      PORT=3000 docker-compose up --build
      ```

5. **Stop the container**:
   ```bash
   # takes care of stopping and removing container for you
   # you could also CTRL + C for graceful stop
   docker-compose down
   ```
   Another way to stop container:
   ```bash
   # stop command
   docker stop wordle
   # remove command
   docker rm wordle

   # or do both in 1 line
   docker stop wordle && docker rm wordle
   ```

**Benefits:**
- ✅ No Flutter installation needed
- ✅ No dependency management
- ✅ Works on any OS with Docker
- ✅ Consistent environment for all users
- ✅ Easy to share and deploy

---

### Development Setup (For Contributors)

If you want to develop or modify the code, you'll need Flutter installed:

#### Prerequisites
- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

Check your Flutter installation:
```bash
flutter doctor
```

#### Installation

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

## Features
- ✅ Hard mode - Toggle to hide tile colors and only show color counts (it was a pain managing guess history haha)
- ✅ Keyboard input support - Type letters and press Enter (added along with original mouse-only support)
- ✅ Flip card animations
- ✅ Color-coded feedback system
- ✅ Responsive design

## Future Enhancements
- [ ] Statistics tracking (games played, win rate)
- [ ] Dark/light theme toggle
- [ ] Share results feature
- [ ] Daily word challenge

## Acknowledgments
- Original Wordle game by Josh Wardle
- Flutter community for documentation
- App Code based from: [https://www.youtube.com/watch?v=_W0RN_Cqhpg&list=LL&index=13]
- Word list sourced from: [https://github.com/darkermango/5-Letter-words?tab=readme-ov-file]
