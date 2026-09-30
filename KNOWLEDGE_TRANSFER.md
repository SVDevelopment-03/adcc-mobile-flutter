# ADCC Mobile Application - Knowledge Transfer Document

## Project Information

**Project Name:** ADCC – Abu Dhabi Cycling Club  
**Project Type:** Cross-Platform Mobile Application  
**Status:** Completed and Deployed  
**Platforms:** iOS & Android  

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Components](#architecture--components)
3. [Key Features Implemented](#key-features-implemented)
4. [Critical Configuration](#critical-configuration)
5. [Deployment & Build Process](#deployment--build-process)
6. [Important Credentials & Access](#important-credentials--access)
7. [Handover Checklist](#handover-checklist)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Maintenance & Support](#maintenance--support)

---

## Project Overview

ADCC is a mobile application developed for the Abu Dhabi Cycling Club, providing iOS and Android applications for club members to engage with cycling activities and community features.

### Development Stack
- **Framework:** Flutter
- **Language:** Dart
- **Platforms:** iOS, Android
- **Backend:** Node.js/TypeScript (separate repository)
- **Frontend Web:** React/TypeScript (separate repository)

### Repository Structure
```
adcc-mobile-flutter/
├── lib/              # Application source code
├── android/          # Android-specific configurations
├── ios/              # iOS-specific configurations
├── assets/           # Images, fonts, icons, animations
├── test/             # Unit and widget tests
├── pubspec.yaml      # Flutter dependencies
└── analysis_options.yaml
```

---

## Architecture & Components

### Core Services
The application implements several critical services located in `lib/core/services/`:

1. **App Update Service** - Backend-controlled version management
2. **Permission Service** - Runtime permissions handling
3. **Authentication Service** - OTP and credential management
4. **Account Management Service** - User profile and settings

### Feature Modules
Application features are organized in `lib/features/` including:
- Authentication & Login
- Splash Screen
- Home Screen
- Community Features
- Challenges & Badges
- And other cycling club features

---

## Key Features Implemented

### 1. OTP-Based Authentication
**Purpose:** Secure user authentication and account management  

**Flow:**
```
User Login
    ↓
OTP Verification
    ↓
Account Creation/Verification
    ↓
Authentication Token Generated
    ↓
User Access Granted
```

**Key Components:**
- Email-based verification
- OTP generation and validation
- Session token management
- Account creation workflow
- Password reset functionality

**Configuration Files:**
- Backend OTP service configuration
- Email sender configuration (see Email Configuration section)

---

### 2. Backend-Controlled App Version Management
**Purpose:** Manage app updates without releasing new app store builds

**Flow:**
```
Backend Version (Configured)
         ↓
Mobile App Version Check
         ↓
Version Comparison Logic
         ↓
Update Decision
    ├─ Yes → Show Update Prompt
    └─ No  → Continue to Application
```

**How It Works:**
1. Backend maintains current/required application version
2. Mobile app checks its installed version on startup
3. Version comparison determines if update is mandatory
4. If update required, user is prompted to update from app store
5. If no update needed, app continues normally

**Key Logic Location:** `lib/core/services/app_update_service.dart`

**Backend Configuration:** 
- Version endpoints in backend controllers
- Version validation rules
- Update requirement policies

---

## Critical Configuration

### Email Configuration
**Email Address:** `hello@adcyclingclub.ae`  
**Email Provider ID/Sender ID:** `ADDARRAJA`  
**Password:** `Adcc@1433`  

**Usage:** 
- OTP delivery
- Account notifications
- Password reset emails

### Application Signing Configuration

#### Android Release Keystore

**Keystore Details:**
- **Location:** `android/app/release-keystore.jks`
- **Alias:** `upload`
- **Store Password:** `Adcc#2026Keystore!`
- **Key Password:** `Adcc#2026Keystore!`
- **Validity:** 10,000 days (until ~2053)

**Keystore Generation Command:**
```bash
keytool -genkeypair -v -keystore android/app/release-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload \
  -storepass Adcc#2026Keystore! -keypass Adcc#2026Keystore! \
  -dname "CN=ADCC, OU=Dev, O=ADCC, L=Abu Dhabi, S=AD, C=AE"
```

**Configuration Files:**
- `android/key.properties` - Keystore path and password reference
- `android/build.gradle.kts` - Signing configuration

#### iOS Configuration
- Provisioning profiles stored in iOS developer account
- Certificate signing identities configured in Xcode
- App ID and team identifiers configured in `ios/Podfile`

### Localization Configuration
**Files:**
- `l10n.yaml` - Localization configuration
- `text_map.md` - Translation mapping
- `assets/locales/` - Locale files directory

---

## Deployment & Build Process

### Release Build Command (Android AAB)

**For Play Store Submission:**
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

**Parameters Explanation:**
- `appbundle` - Generates Android App Bundle (AAB) format for Play Store
- `--release` - Builds in release mode with optimizations
- `--obfuscate` - Obfuscates Dart code for security
- `--split-debug-info=build/app/outputs/symbols` - Separates debug symbols for crash reporting

**Output:** `build/app/outputs/bundle/release/app-release.aab`

### Release Build Process (iOS)
1. Ensure provisioning profiles are up-to-date
2. Update version in `pubspec.yaml`
3. Run Flutter clean: `flutter clean`
4. Build for iOS: `flutter build ios --release`
5. Use Xcode Archive for TestFlight/App Store submission

### Build Artifacts Location
- Android AAB: `build/app/outputs/bundle/release/app-release.aab`
- Debug Symbols: `build/app/outputs/symbols/`
- iOS build: `build/ios/iphoneos/Runner.app`

---

## Important Credentials & Access

### Email Credentials
- **Email:** `hello@adcyclingclub.ae`
- **Password:** `Adcc@1433`
- **Usage:** Email service for OTP and notifications

### Android Keystore
- **Password:** `Adcc#2026Keystore!`
- **Location:** `android/app/release-keystore.jks`

### Google Play Store
- Access via ADCC organization account
- Uses Android keystore for app signing
- All releases must use the same keystore

### Apple App Store
- Access via ADCC developer account
- iOS provisioning profiles and certificates required
- Team ID and App ID configured in project

### Firebase Configuration
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Used for notifications and analytics

### Postman Collection
- `ADCC API Collection.postman_collection 14.json`
- Contains all backend API endpoints
- Useful for testing and integration verification

---

## Handover Checklist

### Before Taking Over the Project, Ensure:

- [ ] Access to GitHub repository with write permissions
- [ ] Firebase project access (Console and CLI)
- [ ] Google Play Store access (Organization account)
- [ ] Apple Developer Account access (Team provisioning)
- [ ] Email account `hello@adcyclingclub.ae` credentials updated in password manager
- [ ] Android keystore file backed up securely
- [ ] iOS provisioning profiles downloaded and refreshed
- [ ] Local development environment set up:
  - [ ] Flutter SDK installed (latest stable)
  - [ ] Android SDK/NDK configured
  - [ ] Xcode installed (for iOS)
  - [ ] CocoaPods installed
  - [ ] Dependencies installed: `flutter pub get`
- [ ] Verify backend connectivity (ensure backend server is running)
- [ ] Test OTP authentication flow
- [ ] Verify app version management functionality
- [ ] Review and understand all environment variables
- [ ] Check Firebase Cloud Messaging configuration
- [ ] Verify analytics tracking is operational

---

## Troubleshooting Guide

### Common Issues & Solutions

#### Issue: OTP Not Received
**Symptoms:** User doesn't receive OTP email  
**Possible Causes:**
1. Email configuration incorrect (`hello@adcyclingclub.ae`)
2. Email provider API issue
3. Backend OTP service not running
4. ADDARRAJA sender ID misconfigured

**Solution:**
1. Verify email credentials in backend environment variables
2. Check backend OTP service logs
3. Test email service manually via backend
4. Ensure SMTP configuration is correct

#### Issue: App Version Check Not Working
**Symptoms:** Users not prompted for updates; version comparison fails  
**Possible Causes:**
1. Backend version endpoint not responding
2. Incorrect version format in backend
3. `app_update_service.dart` logic error
4. Network connectivity issue

**Solution:**
1. Verify backend version endpoint is accessible
2. Check version format matches expected pattern
3. Review `app_update_service.dart` logic
4. Test with proxy to verify network calls

#### Issue: Build Fails with Keystore Error
**Symptoms:** `keytool` or signing error during build  
**Error:** "Keystore not found" or "Invalid keystore password"

**Solution:**
1. Verify keystore exists: `android/app/release-keystore.jks`
2. Verify password: `Adcc#2026Keystore!`
3. Regenerate if necessary using command in Configuration section
4. Ensure `android/key.properties` has correct paths

#### Issue: Firebase Connectivity Problem
**Symptoms:** Notifications not working; Analytics not tracking  
**Possible Causes:**
1. `google-services.json` or `GoogleService-Info.plist` missing
2. Firebase project credentials incorrect
3. Firebase dependencies not initialized
4. Internet connectivity issue

**Solution:**
1. Download latest configuration files from Firebase Console
2. Place in correct locations (Android: `android/app/`, iOS: `ios/Runner/`)
3. Run `flutter pub get` to update dependencies
4. Check Firebase initialization in `main.dart`

#### Issue: Provisioning Profile Issues (iOS)
**Symptoms:** iOS build fails; "Provisioning profile not found"

**Solution:**
1. Update provisioning profiles in Apple Developer account
2. Refresh in Xcode: Xcode → Settings → Accounts → Download Profiles
3. Verify App ID matches configuration
4. Ensure certificates are not expired

---

## Maintenance & Support

### Regular Maintenance Tasks

#### Weekly
- Monitor crash reports in Firebase Crashlytics
- Check user feedback in app store reviews
- Verify backend API health

#### Monthly
- Review and update Flutter/Dart dependencies
- Check for security vulnerabilities: `flutter pub outdated`
- Update Firebase SDKs if new versions available
- Backup keystore and important credentials

#### Quarterly
- Review app analytics for usage patterns
- Update privacy policies if needed
- Audit user authentication flows
- Test complete update process end-to-end

#### Annually
- Renew iOS developer certificates if expired
- Plan for new feature development
- Review and refactor older code modules
- Audit performance and security

### Dependency Management

**Key Dependencies:**
```yaml
firebase_core: ^latest
firebase_messaging: ^latest
flutter_secure_storage: ^latest
dio: ^latest  # API client
get_it: ^latest  # Service locator
```

View complete list in `pubspec.yaml`

### Testing

**Run Unit Tests:**
```bash
flutter test test/app_update_service_test.dart
flutter test test/permission_service_test.dart
```

**Run Static Analysis:**
```bash
flutter analyze lib/features/
```

**Build APK for Testing:**
```bash
flutter build apk --release
```

### Performance Monitoring

- Firebase Performance Monitoring enabled
- Crashlytics configured for error tracking
- Analytics tracking app usage
- Monitor build size regularly

---

## Useful Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run development app
flutter run

# Hot reload during development
flutter run -v

# Run with specific device
flutter run -d <device-id>
```

### Analysis & Testing
```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Generate code coverage
flutter test --coverage
```

### Building
```bash
# Build APK
flutter build apk --release

# Build AAB for Play Store
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

# Build iOS
flutter build ios --release

# Clean build
flutter clean
```

### Debugging
```bash
# Verbose output
flutter run -v

# Debug specific file
flutter analyze lib/path/to/file.dart

# Use Dart DevTools
flutter pub global activate devtools
devtools
```

---

## Support & Resources

### Documentation References
- [Flutter Official Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)

### Backend Integration
- Backend repository: `d:\adcc-backend`
- Backend README for API documentation
- Postman collection: `ADCC API Collection.postman_collection 14.json`

### Frontend Web
- Frontend repository: `d:\adcc-frontend-web`
- Shared design patterns and UI components may reference web implementation

---

## Contact & Escalation

### For Technical Issues
1. Review this Knowledge Transfer document
2. Check Troubleshooting Guide section
3. Review backend logs for API-related issues
4. Check Firebase Console for service health

### Critical Issues
- App not launching: Check Firebase configuration and permissions
- Users cannot authenticate: Verify backend OTP service
- App crashes: Review Crashlytics in Firebase Console
- Performance issues: Check Firebase Performance Monitoring

---

## Version History

| Version | Date       | Changes |
|---------|------------|---------|
| 1.0     | 2026-09-29 | Initial Knowledge Transfer Document |

---

**Document Created:** September 29, 2026  
**Last Updated:** September 29, 2026  
**Next Review Date:** December 29, 2026

---

*This document should be reviewed and updated as the project evolves and new features are added.*
