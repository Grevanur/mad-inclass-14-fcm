# Activity 14 Graduate Reflection

## 1. Setup and payload

I used one Android target and a dedicated Firebase project. I centralized the listeners in `FCMService` so the widget owns one service and cleanup path. The payload accepts only `action=update_ui` and maps `asset=default` or `promo` through a local allowlist, preventing arbitrary asset paths. T1 showed the valid payload reaching `onMessage` and selecting the promo image. Generative AI assisted with planning, implementation, setup, testing, and documentation; unobserved cases remain blocked.

## 2. Lifecycle and evidence

`onMessage` handles visible-app receipt. `onMessageOpenedApp` handles a background notification tap, while `getInitialMessage` checks whether a tap launched a terminated app. The top-level `onBackgroundMessage` handler runs background-safe work in a separate isolate and cannot update widgets. Permission authorizes notifications but does not guarantee delivery. T1 proved foreground receipt. A background send produced a notification and `onBackgroundMessage`, but the Android 17 emulator did not complete the automated tap, so T2 and T3 remain blocked rather than inferred.

## 3. Validation and next step

The validator rejects an unknown asset before changing content. T4 showed a fresh `onMessage`, increased count, rejection diagnostic, and preserved promo UI without a crash. `mounted` and disposal guards prevent callbacks from updating dead widget state. One emulator cannot establish universal delivery. I chose bundled allowlisted assets because they are deterministic; a backend fetch supports changing content but adds network and caching failures. A feasible improvement is duplicate-event detection: sending one event ID twice should apply content once and mark the second delivery as a duplicate.

## Evidence limitation

The three responses above total approximately 230 words. T2 and T3 must be manually completed before the submission can honestly claim all four lifecycle tests passed.
