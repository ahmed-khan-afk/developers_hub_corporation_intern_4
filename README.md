# NeuConnect — Flutter API Integration & Networking (Week 4)

A Flutter app built for **Week 4 of the Flutter Developers Internship (Cycle 2)** — *API Integration and Networking*. It fetches live data from a public REST API, parses the JSON, and renders it in a fully custom **Neumorphic (Soft UI)** interface, complete with search, pull-to-refresh, loading states, and typed error handling.

> Internship task reference: *Week 4 — HTTP Requests & JSON Parsing, User Profile Screen, Error Handling & Loading Indicators.*

---

## Why Neumorphism (and not plain Material)?

The task only required "an app that fetches and displays API data," which left the visual direction open. Plain Material widgets (default `Card`, `ListTile`) tend to look like every other tutorial app, so this project uses a **hand-built Neumorphic ("Soft UI") design system** instead — surfaces appear molded out of a single soft background using paired light/dark shadows rather than flat elevation or borders.

Pure neumorphism can look low-contrast and inaccessible on its own, so it's blended with **one confident accent gradient** (indigo → cyan) for buttons, avatars, badges, and the active tab, plus soft "concave" (pressed-in) styling for inputs. This keeps the tactile, premium feel of neumorphism while avoiding its usual readability problems — a small hybrid upgrade beyond what was asked for.

All of this lives in a **reusable widget library** (`lib/widgets/neumorphic.dart`), so the same `NeuBox` / `NeuButton` / `NeuSearchField` primitives are reused across every screen instead of being copy-pasted.

---

## Features implemented

| Task requirement | Where it lives |
|---|---|
| HTTP requests with the `http` package | `lib/services/api_service.dart` |
| JSON parsing into typed models | `lib/models/post.dart`, `lib/models/app_user.dart` |
| Data displayed in a `ListView` | `lib/screens/posts_screen.dart` |
| User Profile Screen (name, email, photo) | `lib/screens/user_profile_screen.dart` |
| Robust error handling | `lib/services/api_exceptions.dart` + `ErrorView` widget |
| Loading indicators | Custom `NeuLoadingIndicator` + `LoadingView` widget |

**Extras added on top of the brief:**
- Live **search/filter** on the posts list.
- **Pull-to-refresh** on both list screens.
- A **Users directory** (`/users`) in addition to the single profile screen, each row deep-linking into the full profile.
- Post detail screen that fetches and links to the **post's author** (`/users/:id`), showing how multiple endpoints compose together.
- Distinct **empty state** (e.g. "no search results") separate from the error state.
- Deterministic per-user **avatar images** (JSONPlaceholder has no photo field) with automatic **initials fallback** if an image fails to load.

---

## API used

[JSONPlaceholder](https://jsonplaceholder.typicode.com) — a free fake REST API, exactly as suggested in the task brief.

| Endpoint | Used for |
|---|---|
| `GET /posts` | Posts ListView |
| `GET /users` | Users directory |
| `GET /users/:id` | Single user profile / a post's author |

---

## Error handling strategy

`ApiService` never lets a raw exception escape — every failure is normalized into a typed subclass of `ApiException` (`lib/services/api_exceptions.dart`):

- `NoConnectionException` — device offline / socket failure
- `TimeoutApiException` — request exceeded a 12s timeout
- `ServerException(statusCode)` — non-2xx HTTP response
- `ParsingException` — malformed/unexpected JSON shape
- `UnknownApiException` — anything else, as a safety net

Screens catch `ApiException` and show a friendly message with a **Try Again** button (`ErrorView`) — the user is never shown a raw stack trace or "Exception: ...".

---

## Project structure

```
lib/
├── main.dart                     # App entry point + MaterialApp
├── models/
│   ├── post.dart                 # Post model + JSON mapping
│   └── app_user.dart             # User/Address/Company models
├── services/
│   ├── api_service.dart          # All networking, timeouts, parsing
│   └── api_exceptions.dart       # Typed exception hierarchy
├── theme/
│   └── app_theme.dart            # Neumorphic color tokens + ThemeData
├── widgets/
│   ├── neumorphic.dart           # NeuBox, NeuButton, NeuSearchField, NeuLoadingIndicator
│   ├── neu_avatar.dart           # Circular avatar w/ fallback initials
│   ├── post_card.dart            # List row for a Post
│   └── status_views.dart         # LoadingView, ErrorView, EmptyView
└── screens/
    ├── root_shell.dart           # Bottom-nav shell (Posts / Users tabs)
    ├── posts_screen.dart         # Task 1: fetch + list + search
    ├── post_detail_screen.dart   # Full post + author chip
    ├── users_screen.dart         # Users directory list
    └── user_profile_screen.dart  # Task 2: Profile Screen
```

---

## Getting started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.19+ (Dart 3.3+)
- An emulator/simulator or physical device, or any desktop/web target enabled in your Flutter install

### Setup

This deliverable ships the app's **source code** (`lib/`), `pubspec.yaml`, and this `README.md`. Platform runner folders (`android/`, `ios/`, `web/`, etc.) are intentionally not included since they're auto-generated boilerplate — regenerate them locally with `flutter create .`:

```bash
# 1. Unzip the project, then from its root:
flutter create .              # generates android/ ios/ web/ etc. around the existing lib/

# 2. Install dependencies
flutter pub get

# 3. Run it
flutter run                   # pick a connected device/emulator, or:
flutter run -d chrome         # to run in a browser
```

An internet connection is required at runtime since every screen fetches live data from JSONPlaceholder and avatar images from pravatar.cc.

### Try the error handling
Turn off Wi-Fi/data (or use airplane mode) and pull-to-refresh — you'll see the neumorphic error card with a **Try Again** button instead of a crash.

---

## Tech stack

- **Flutter** (Material app shell, custom widget layer on top)
- [`http`](https://pub.dev/packages/http) — networking
- [`google_fonts`](https://pub.dev/packages/google_fonts) — Poppins typeface
- Zero external UI kit — the neumorphic components are hand-built with `BoxShadow`/`BoxDecoration`, kept deliberately dependency-free so the design system is easy to audit and extend for Weeks 5–6.

---

## Roadmap (Weeks 5–6, not part of this deliverable)

- Week 5: Firebase Authentication (Email/Password) + Firestore for persisting user data.
- Week 6: Refactor state handling onto `provider`, extend the To-Do/Task app, add animations, and record the final walkthrough video.

---

## License
Built for internal internship coursework use.
