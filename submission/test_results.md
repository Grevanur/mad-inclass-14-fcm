# Activity 14 Test Results

## Test context

- Device: Android Studio Medium Phone emulator (`sdk gphone16k arm64`)
- OS: Android 17, API 37
- App ID: `edu.gsu.inclass_14`
- Firebase project: `mad-inclass14-gowtham-2026`
- Notification permission: Authorized
- Valid payload: `payloads/valid_payload.json`
- T4 change: `asset` changed from `promo` to `unknown`
- Full FCM registration token: intentionally omitted

## Result rows

| Test | Expected handler/result | Observed result | Status | Evidence |
|---|---|---|---|---|
| T1 — Foreground | `onMessage`; title and image change to the promo content | Real FCM message received by `onMessage`; receipt count became 1; message ID changed; title and promo image were visible | Pass | `evidence/T1_foreground.png` |
| T2 — Background tap | Notification tap returns through `onMessageOpenedApp` and applies the UI | A real background notification was delivered, and the separately registered `onBackgroundMessage` handler ran. The Android 17 emulator notification shade did not reliably accept the automated tap, so `onMessageOpenedApp` was not observed | Blocked | `evidence/T2_notification.png`; runtime observation recorded below |
| T3 — Cold-start tap | Notification-triggered launch is handled by `getInitialMessage`; count starts at 1 | Not completed because a reliable notification tap could not be performed in this emulator session. No claim is made for `getInitialMessage` | Blocked | No passing evidence |
| T4 — Invalid payload | `onMessage`; visible rejection; previous title/image preserved; no crash | Real FCM message with `asset=unknown` reached `onMessage`; metadata advanced; the diagnostic was visible; “New promotion” and the promo image remained unchanged; app did not crash | Pass | `evidence/T4_invalid_payload.png` |

## Runtime observations

- T1 message ID shown in the app: `0:1794351147041349%a82df1aca82df1ac`.
- A background send produced `onBackgroundMessage` for message ID `0:1794351463205785%a82df1aca82df1ac` and a visible system notification.
- T4 message ID shown in the app: `0:1794351528734429%a82df1aca82df1ac`.
- The development build generated a current FCM token, but it is redacted from all submission material.

## Static verification

- `flutter test`: five payload-validation tests passed.
- `flutter analyze`: no issues found.
- Android debug build: succeeded.
- Installation and clean configured launch on the emulator: succeeded.

## Retest required before claiming full completion

Perform T2 and T3 manually on a compatible Android device or stable emulator. For T2, background the running app, send the valid payload, tap the notification, and capture `Last handler: onMessageOpenedApp`. For T3, remove the app from recents without force-stopping it, send the valid payload, tap the notification, and capture `Last handler: getInitialMessage` with a launch count of 1. Replace the blocked rows only after observing those results.
