# Driftinn App (Flutter Client) 📱

This directory contains the source code for the **Driftinn** mobile application.

## 📂 Project Structure

Verified breakdown of the codebase:

### Root Directory
- **`lib/`**:  Main source code.
- **`manifest.lock`**: Dependency lockfile.
- **`pubspec.yaml`**: Dart package dependencies.
- **`firebase.json`**: Firebase Emulator & Hosting configuration.
- **`functions/`**: Backend Cloud Functions (Node.js).

### Source Code (`lib/`)

#### **`main.dart`**
- **Entry Point**: Initializes the app.
- **Configuration**: Sets up Firebase (with Windows fallbacks), Riverpod ProviderScope, and the main MaterialApp.

#### **`features/`** (Modular Feature Architecture)
- **`auth/`**: Authentication Logic.
    - **`screens/`**:
        - `login_screen.dart`: The main login UI (Tabs for Email/Phone).
        - `otp_screen.dart`: UI for entering the 6-digit verification code.
    - **`controller/`**:
        - `auth_controller.dart`: Riverpod StateNotifier managing auth state and navigation logic.
    - **`repository/`**:
        - `auth_repository.dart`: Handles data interactions with Firebase Auth and Cloud Functions. includes **Windows-specific REST fallbacks** for local development.

#### **`branding/`** (or `core/`)
- **`theme.dart`**: Contains the app's color palette, text styles, and theme data.

#### **`providers/`**
- **`app_providers.dart`**: Global Riverpod providers.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Node.js (for Firebase Tools)
- Firebase CLI (`npm install -g firebase-tools`)

### 1. Setup Environment
```bash
# Install dependencies
flutter pub get
```

### 2. Start Backend (Emulators)
To develop locally without affecting the live database:
```bash
firebase emulators:start --project driftinn
```
*Keep this terminal running.*

### 3. Run the App
```bash
# Run on Windows (Debug)
flutter run -d windows
```

---

## 🧪 Testing & Verification

### Authentication Flow (Local)
1. **Email**: Enter any valid `.edu` email. (Mocked success).
2. **Phone**: Enter a phone number (e.g. `+1551234567`).
3. **OTP**:
    - The emulator **will not** send a real SMS.
    - Check the **Emulator Logs** (Terminal or `http://127.0.0.1:4000/logs`) for the 6-digit code.
    - Enter code in `OTPScreen`.
4. **Account Check**:
    - The app automatically checks if the user exists via Cloud Functions (`accountCheck`).
    - Redirects to Onboarding (New User) or Home (Existing).

---

## ⚠️ Windows Development Notes
- **Google Services**: `google-services.json` is **not required** for Windows debug builds connecting to emulators. A dummy options workaround is implemented in `main.dart`.
- **Cloud Functions**: Direct SDK calls (`functions.httpsCallable`) can be unstable on Windows. We use a **REST API Fallback** (`http.post`) in `AuthRepository` when `kDebugMode` is true.

---

## 🔒 License
Proprietary software. See root `LICENSE` file.
