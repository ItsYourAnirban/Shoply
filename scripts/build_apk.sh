#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

pushd "$ROOT_DIR/app" >/dev/null
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required: https://flutter.dev/docs/get-started/install" >&2
  exit 1
fi
if [ ! -f "pubspec.lock" ] || [ ! -d "android" ] || [ ! -d "ios" ]; then
  flutter create .
fi
flutter pub get
flutter build apk --release --dart-define=SHOPLY_API_BASE=${SHOPLY_API_BASE:-http://localhost:8080}
popd >/dev/null
