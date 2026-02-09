# TurboFireAuth

A Flutter package for easy and clean Firebase Authentication.  
Simplify your auth logic with a clean, singleton-based approach supporting Email/Password and Google Sign-In out of the box.

> **Note**: If your project is initialized with the **FlutterFire CLI**, providing `FirebaseOptions` to the `initialize` method is **not required**, as it will be handled by the system's default configuration.

[![pub package](https://img.shields.io/pub/v/turbo_fireauth.svg)](https://pub.dev/packages/turbo_fireauth)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

---

## Features

* **Clean Singleton API**: Access everything via `TurboFireAuth.instance`.
* **Multiple Auth Providers**: Supports Email/Password (Login & Register), Facebook, X(Twitter), Yahoo and Google Sign-In.
* **Comprehensive Results**: Instead of catching exceptions, handle specific `LoginResult` types.
* **User Management**: Easy methods for password reset, profile updates, and current user retrieval.
* **Ready for Web & Mobile**: Handles persistence and platform-specific logic internally.

---

## Installation

Add `turbo_fireauth` to your `pubspec.yaml`:

```yaml
dependencies:
  turbo_fireauth: ^0.0.8
```

Then run:
```bash
flutter pub get
```

---

## Usage

### 1. Initialization
Initialize the package in your `main.dart` before calling any auth methods.

```dart
import 'package:turbo_fireauth/turbo_fireauth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await TurboFireAuth.instance.initialize(
    // Optional: provide FirebaseOptions for manual initialization
    // If using FlutterFire CLI, this is handled automatically.
    // options: DefaultFirebaseOptions.currentPlatform,
    googleSigninConfig: GoogleSigninConfig(
      clientId: "YOUR_GOOGLE_CLIENT_ID",
    ),
  );
  
  runApp(MyApp());
}
```

### 2. Login / Register

#### Email Login
```dart
final result = await TurboFireAuth.instance.login(
  EmailLogin("user@example.com", "password123"),
);

if (result is Success) {
  print("Welcome ${result.user.email}!");
} else if (result is WrongPasswordFailure) {
  print("Oops, wrong password.");
}
```

#### Google Sign-In
```dart
final result = await TurboFireAuth.instance.login(GoogleLogin());
```

### 3. User Actions

```dart
// Logout
await TurboFireAuth.instance.logout();

// Get Current User
final user = await TurboFireAuth.instance.getCurrentUser();

// Reset Password
await TurboFireAuth.instance.sendPasswordResetEmail("user@example.com");

// Update Profile
await TurboFireAuth.instance.updateUserName("New Name");
```

---

## Handling Results

`TurboFireAuth` returns a `LoginResult` for all login operations, making error handling predictable:

* `Success`: Login successful, contains the `User`.
* `EmailAlreadyExistsFailure`: Registration failed because email is in use.
* `WrongCredentials`: Invalid email or password.
* `UserDisabledFailure`: The user account has been disabled.
* `LoginCancelledFailure`: User closed the login popup/modal.
* And many more...

---

## Contribution

Feel free to open issues or submit pull requests to help improve this package!

## License

This project is licensed under the Apache License 2.0.
