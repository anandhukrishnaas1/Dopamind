# DopamineOS - Android Setup Guide

This guide walks you through converting the web app into a native Android app using Capacitor.

## Prerequisites

- Node.js 18+
- Java Development Kit (JDK) 11+
- Android SDK & Android Studio
- Git

## Step 1: Clone and Setup

```bash
git clone https://github.com/anandhukrishnaas1/Dopamind.git
cd Dopamind
pnpm install
```

## Step 2: Initialize Capacitor

```bash
npm install @capacitor/core @capacitor/cli --save-dev
npx cap init DopamineOS com.dopamind.app
```

When prompted:
- App name: `DopamineOS`
- App ID: `com.dopamind.app`
- Web dir: `out` (if using static export) or `.next` (if using SSG)

## Step 3: Add Android Platform

```bash
npx cap add android
```

This creates an `android/` folder containing the native Android project.

## Step 4: Build Web Assets

```bash
pnpm build
npx cap copy android
```

## Step 5: Open in Android Studio

```bash
npx cap open android
```

This opens Android Studio with the project ready to build.

## Step 6: Configure Android Project

1. **In Android Studio:**
   - Wait for Gradle to sync
   - Go to `Build > Generate Signed Bundle / APK`
   - Select `APK` and follow the wizard
   - Create a keystore file (save it securely)
   - Sign and build the APK

2. **Optional: Set Minimum SDK**
   - Edit `android/app/build.gradle`
   - Ensure `minSdkVersion` is 21 or higher

## Step 7: Test on Device/Emulator

```bash
# Connect Android device via USB or use Android Emulator
npx cap run android
```

## Building for Release

```bash
# Build optimized web assets
pnpm build

# Copy to Android
npx cap copy android

# In Android Studio:
# Build > Generate Signed Bundle / APK > APK
# Select "Release" configuration
```

The APK will be generated in `android/app/release/`

## Publishing to Play Store

1. Create a Google Play Developer account ($25 one-time fee)
2. Create an app listing in Google Play Console
3. Upload the signed APK/AAB
4. Fill in app details, screenshots, and descriptions
5. Submit for review (usually takes 2-4 hours)

## Capacitor Plugins

To add native features, use Capacitor plugins:

```bash
# Example: Add camera access
npm install @capacitor/camera
npx cap sync

# Then use in your app
import { Camera } from '@capacitor/camera';
```

## Troubleshooting

### App won't build
```bash
# Clear Gradle cache
cd android
./gradlew clean
cd ..
npx cap copy android
```

### Changes not showing on device
```bash
# Rebuild and sync
pnpm build
npx cap copy android
npx cap run android
```

### Web assets not loading
- Ensure `pnpm build` completes without errors
- Check that web assets exist in the output directory
- Run `npx cap copy android` again

## Next Steps

1. Add native features using Capacitor plugins
2. Implement push notifications
3. Add device permissions (camera, microphone, contacts)
4. Test on multiple Android versions
5. Submit to Play Store

## Resources

- [Capacitor Documentation](https://capacitorjs.com/)
- [Android Studio Guide](https://developer.android.com/studio)
- [Google Play Console](https://play.google.com/console)

## Support

For issues with Capacitor, check the official documentation or community forums.
