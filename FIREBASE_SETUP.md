# Firebase Setup Guide for Driftinn

Follow these steps to fully connect your Flutter app to your Firebase backend.

## Prerequisites
- **Node.js**: Ensure you have Node.js installed to run the Firebase CLI. [Download here](https://nodejs.org/).
- **Firebase Account**: You need a Google account and a project created in the [Firebase Console](https://console.firebase.google.com/).

## Step 1: Install Tools
Open your terminal (PowerShell or Command Prompt) and run:

1.  **Install Firebase CLI:**
    ```bash
    npm install -g firebase-tools
    ```

2.  **Login to Firebase:**
    ```bash
    firebase login
    ```

3.  **Install FlutterFire CLI:**
    ```bash
    dart pub global activate flutterfire_cli
    ```

## Step 2: Configure the App
This command will automatically verify your project, create the apps in the Firebase console, and download the necessary configuration files (`google-services.json`, `GoogleService-Info.plist`, and `firebase_options.dart`).

Run this command in the root of your project (`d:\College startup\Driftinn`):

```bash
flutterfire configure
```

- When prompted, select your **Firebase Project** (Driftinn).
- Select the platforms you want to support (Android, iOS, Web, Windows).

## Step 3: Update Code
Once `flutterfire configure` is finished, it will generate a file at `lib/firebase_options.dart`.

Now, we need to update `lib/main.dart` to use these options instead of the temporary bypass we added.

Open `lib/main.dart` and modify the `main()` function:

```dart
// Import the generated options
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Use the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## Step 4: Verify
Run the app again:
```bash
flutter run
```
If the app launches without errors and you see the login screen, you are fully connected!
