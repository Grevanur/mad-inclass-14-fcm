# Activity 14: Firebase Cloud Messaging

This Android Flutter app demonstrates Firebase Cloud Messaging receipt and payload-driven UI updates across app lifecycle states.

## Implemented behavior

- Firebase initializes before `runApp` using generated FlutterFire options.
- A top-level background handler is registered before widgets start.
- `FCMService` owns foreground, notification-open, cold-start, and token-refresh listeners.
- The UI displays the last handler, launch receipt count, message ID, and diagnostic status.
- Only `action=update_ui` with `asset=default` or `asset=promo` is accepted.
- Invalid payloads update receipt metadata while preserving the previous title and image.
- Stream subscriptions are canceled and callbacks are guarded after disposal.

## Configuration

- Platform: Android
- Application ID: `edu.gsu.inclass_14`
- Firebase project: `mad-inclass14-gowtham-2026`
- Firebase Core: 4.x
- Firebase Messaging: 16.x

## Run and verify

Generate the local Firebase configuration before building:

```text
flutterfire configure --project=mad-inclass14-gowtham-2026 --platforms=android --android-package-name=edu.gsu.inclass_14
```

The generated `android/app/google-services.json` and `lib/firebase_options.dart`
files are intentionally excluded from version control.

```text
flutter pub get
flutter test
flutter analyze
flutter run
```

Use the payloads in `submission/payloads`. Never publish or submit a full FCM registration token. The tested emulator and evidence status are documented in `submission/test_results.md`.

