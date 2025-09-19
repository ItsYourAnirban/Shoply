# Shoply App (Flutter)

A lightweight Flutter app that lets users search once and compare product prices across platforms, add to a local comparison cart, and jump to the store.

Features
- Typeahead-style search (submit to fetch results)
- Location opt-in (used to tailor availability)
- Horizontal per-platform result strips with Not available when missing
- Comparison cart (local) with add/remove & redirect-to-store
- Platform filter toggle
- Color system (60/30/10):
  - Background/Base (60%): #F9F9F9
  - Primary (30%): #A8E6CF
  - Accent (10%): #FFD5C2
  - Highlight (offers): #FFB347

Setup
1) Ensure Flutter SDK is installed: https://flutter.dev/docs/get-started/install
2) Initialize platform scaffolding (if not present):
   cd app && flutter create .
3) Configure backend base URL (defaults to http://localhost:8080). To override at build time:
   flutter run --dart-define=SHOPLY_API_BASE=https://your-backend
4) Install deps and run:
   flutter pub get
   flutter run

Build APK
- flutter build apk --release --dart-define=SHOPLY_API_BASE=https://your-backend

Notes
- iOS requires additional signing steps; see Flutter docs.
- No login, no push notifications.
