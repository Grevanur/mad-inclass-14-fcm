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
| T2 — Background tap | Notification tap returns through `onMessageOpenedApp` and applies the UI | A real background notification was delivered and tapped; the app returned through `onMessageOpenedApp`, applied the promo payload, and displayed the matching message ID | Pass | `evidence/T2_background_tap.png` |
| T3 — Cold-start tap | Notification-triggered launch is handled by `getInitialMessage`; count starts at 1 | The background app process was ended, a real notification was delivered and tapped, and the new launch displayed `getInitialMessage` with a launch count of 1 | Pass | `evidence/T3_cold_start_tap.png` |
| T4 — Invalid payload | `onMessage`; visible rejection; previous title/image preserved; no crash | Real FCM message with `asset=unknown` reached `onMessage`; metadata advanced; the diagnostic was visible; “New promotion” and the promo image remained unchanged; app did not crash | Pass | `evidence/T4_invalid_payload.png` |

## Runtime observations

- T1 message ID shown in the app: `0:1794368000800241%a82df1aca82df1ac`.
- T4 message ID shown in the app: `0:1794368013140871%a82df1aca82df1ac`.
- T2 message ID shown in the app: `0:1794368026737934%a82df1aca82df1ac`.
- T3 message ID shown in the app: `0:1794368229735726%a82df1aca82df1ac`.
- The development build generated a current FCM token, but it is redacted from all submission material.

## Static verification

- `flutter test`: five payload-validation tests passed.
- `flutter analyze`: no issues found.
- Android debug build: succeeded.
- Installation and clean configured launch on the emulator: succeeded.

## Completion note

All four required runtime cases were observed on the listed emulator. The full FCM token and generated Firebase client configuration are intentionally excluded from submission materials and version control.
