<div align="center">
  <img src="assets/images/logo.png" alt="Yumm AI Logo" width="120"/>
  <h1>Yumm AI</h1>
  <p><strong>AI-Powered Meal Recommendation App</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.9.2-02569B?style=flat-square&logo=flutter" alt="Flutter"/>
    <img src="https://img.shields.io/badge/Dart-3.9.2-0175C2?style=flat-square&logo=dart" alt="Dart"/>
    <img src="https://img.shields.io/badge/Gemini_AI-Google-4285F4?style=flat-square&logo=google" alt="Gemini AI"/>
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=flat-square&logo=flutter" alt="Platform"/>
  </p>
</div>

---

## About

Yumm AI is a Flutter mobile app (iOS & Android) that uses Google Gemini AI to help users discover recipes, plan meals, manage their pantry, and get personalized cooking guidance.

---

## Features

- **AI Recipe Generation** — Generate recipes from your pantry items, dietary preferences, and cuisine choices using Gemini AI
- **Recipe Discovery** — Browse and search public recipes with filters (meal type, cuisine, calories, experience level)
- **Cookbook** — Save, customize, and track your personal recipe collection
- **Step-by-Step Cooking** — Cook recipes with guided step-by-step instructions and progress tracking
- **Pantry Inventory** — Track your kitchen ingredients and scan fridge photos for AI ingredient detection
- **Shopping List** — Auto-generate shopping lists from recipes or add items manually
- **Meal Planning** — AI-assisted weekly and monthly meal plans
- **Chef Profiles** — Explore other users' public recipes and profiles
- **Push Notifications** — Real-time notifications via Pushy
- **Subscriptions** — 7-day free trial + Pro tier (monthly/annual) via RevenueCat
- **Bug Reporting** — Shake device to report bugs with an automatic screenshot
- **Google Sign-In** — Sign in with Google or email/password

---

## Tech Stack

| Category | Package | Version |
|---|---|---|
| State Management | `flutter_riverpod` | ^3.1.0 |
| Navigation | `go_router` | ^17.0.0 |
| AI | `flutter_gemini`, `google_generative_ai` | ^3.0.0 / ^0.4.7 |
| HTTP Client | `dio` + `dio_smart_retry` | ^5.9.0 |
| Local Storage | `hive` + `hive_flutter` | ^2.2.3 |
| Secure Storage | `flutter_secure_storage` | ^10.0.0 |
| Google Auth | `google_sign_in` | ^6.2.2 |
| Subscriptions | `purchases_flutter` (RevenueCat) | ^9.12.2 |
| Push Notifications | `pushy_flutter` | ^2.0.43 |
| Image Handling | `image_picker`, `cached_network_image` | ^1.2.1 / ^3.4.1 |
| Animations | `lottie`, `shimmer` | ^3.3.2 / ^3.0.0 |
| Architecture | `dartz`, `freezed`, `equatable` | — |

---

## Project Structure

```
lib/
├── main.dart               # Entry point (Gemini, RevenueCat, Pushy init)
├── app.dart                # Root widget + GoRouter setup
├── core/                   # Shared utilities
│   ├── api/                # Dio HTTP client config
│   ├── constants/          # App-wide constants & enums
│   ├── error/              # Failure/error models
│   ├── providers/          # Global Riverpod providers
│   ├── services/           # Storage & auth token services
│   └── utils/              # Helper functions
├── app/
│   ├── routes/             # GoRouter navigation definitions
│   └── theme/              # Colors & typography
└── features/               # Feature modules (Clean Architecture)
    ├── auth/               # Login, signup, Google OAuth
    ├── home/               # Home feed & dashboard
    ├── chef/               # Chef profiles & AI recipe generation
    ├── cooking/            # Step-by-step cooking mode
    ├── cookbook/           # Personal recipe collection
    ├── pantry_inventory/   # Kitchen inventory management
    ├── shopping_list/      # Smart shopping list
    ├── search/             # Recipe search & filters
    ├── profile/            # User profile
    ├── settings/           # App settings
    ├── notifications/      # Push notification handling
    ├── subscription/       # RevenueCat subscription flow
    └── bug_report/         # In-app bug reporting
```

Each feature follows Clean Architecture:

```
features/<name>/
├── data/           # Models, data sources, repository implementations
├── domain/         # Entities, use cases, abstract repositories
└── presentation/   # Screens, widgets, Riverpod view models
```

---

## Architecture

The app uses **Clean Architecture** with **MVVM** and **Riverpod** for state management.

```
Screens / Widgets
      ↕
Riverpod ViewModels
      ↕
Use Cases (Domain)
      ↕
Repository Implementations (Data)
      ↕
Remote API  /  Local Hive Database
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.9.2
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for emulator or physical device
- A running instance of the Yumm AI backend server

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Create your environment file
cp .env.example .env
# Fill in your API keys (see Environment Variables below)

# 3. Run the app
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Environment Variables

Create a `.env` file in the project root:

```env
API_BASE_URL=http://localhost:5000/api
GEMINI_API_KEY=your_gemini_api_key
GOOGLE_CLIENT_ID=your_google_client_id
REVENUECAT_API_KEY=your_revenuecat_api_key
PUSHY_APP_ID=your_pushy_app_id
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

*College Project — Yumm AI*
