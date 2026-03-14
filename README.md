# DopaMind Flutter App

A Flutter mobile app (Android/iOS) for **DopamineOS – AI Digital Behavior Prediction System**. Helps users control smartphone addiction by predicting dopamine-driven behavior and intervening in real-time.

## Features

- 🧠 **Dopamine Score Tracking** – Real-time dopamine level monitoring with score visualization
- 🛡️ **Smart Focus Mode** – Study, Work, and Digital Detox modes with live timer
- 📊 **Analytics Dashboard** – Weekly charts for dopamine score, focus time, and screen time
- 🤖 **AI Habit Coach** – Personalized suggestions and daily goals
- 🔥 **Streak Tracking** – Daily progress monitoring with weekly overview
- 🌙 **Dark Mode** – Full dark theme support
- 💾 **Persistent State** – Settings and auth state saved across app launches

## Getting Started

### Prerequisites

1. **Install Flutter SDK**: Follow [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. **Set up Android Studio** or **Xcode** for the target platform
3. Verify installation:
   ```bash
   flutter doctor
   ```

### Run the App

```bash
cd dopamind
flutter pub get
flutter run
```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires Mac + Xcode):**
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry point & shell
├── theme/
│   └── app_theme.dart           # Light/dark theme definitions
├── store/
│   └── app_store.dart           # State management (Provider + SharedPreferences)
├── screens/
│   ├── onboarding_screen.dart   # 4-slide intro carousel
│   ├── auth_screen.dart         # Login/signup/forgot password
│   ├── dashboard_screen.dart    # Main dashboard with dopamine score
│   ├── analytics_screen.dart    # Charts & usage analytics
│   ├── focus_mode_screen.dart   # Focus timer & mode selection
│   ├── habit_coach_screen.dart  # AI suggestions & daily goals
│   └── settings_screen.dart     # App settings & profile
└── widgets/
    └── bottom_nav.dart          # Bottom navigation bar
```

## Tech Stack

- **Flutter** – Cross-platform UI framework
- **Provider** – State management
- **SharedPreferences** – Local data persistence
- **fl_chart** – Charts & data visualization
- **Google Fonts** – Inter font family
- **animate_do** – Smooth animations
