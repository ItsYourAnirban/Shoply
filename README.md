# Shoply — One search, all stores, best price.

This monorepo contains a production-ready skeleton of Shoply with a Flutter app and a Node/TypeScript backend aggregator.

Quick start
- Backend (Docker):
  docker compose up --build -d
  The API will be on http://localhost:8080

- App (Flutter):
  cd app
  flutter create .
  flutter pub get
  flutter run --dart-define=SHOPLY_API_BASE=http://localhost:8080

Deliverables included
- Flutter source: app/
- Backend aggregator: backend/
- Docker setup: backend/Dockerfile, docker-compose.yml
- Two connectors:
  - Real/legal: FakeStore (public API)
  - Mock: MockBlinkit (location-scoped availability + demo data)
- README: root + subproject READMEs
- APK build script: scripts/build_apk.sh (build locally with Flutter SDK)

Design (colors and usage)
- 60/30/10 color rule with exact tokens:
  - Background/Base (60%): #F9F9F9
  - Primary (30%): #A8E6CF
  - Accent (10%): #FFD5C2
  - Highlight (offers): #FFB347

Legal and data sources
- Do not use scraping/MITM. Integrate only with official/public APIs or with explicit permission. This codebase ships a legal public API example and a mock adapter. Adapters are pluggable for future integrations.

Extending adapters
- See backend/src/platforms/*.ts and backend/src/platforms/registry.ts for the adapter interface and registration.
