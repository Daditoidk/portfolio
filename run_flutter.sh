#!/bin/bash

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "📦 Getting Flutter dependencies..."
flutter pub get

flutter analyze

dart fix --dry-run

dart fix --apply

echo "🚀 Running Flutter app in Chrome..."
flutter run -d chrome 