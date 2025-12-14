# Sports Facility Companion

Modern Flutter app that demonstrates Firebase Authentication, Cloud Firestore, and Firebase Realtime Database working together for a sports facility booking experience.

## Features

- **Authentication**
  - Email/password registration with role dropdown plus onboarding date/time pickers.
  - Google sign-in and password reset flow.
  - User roles and preferred schedules stored in Firestore.
- **Firestore workflows**
  - Booking form with CRUD operations and live stream-backed list.
  - Cart per user with add-to-cart and buy-now actions from the explore catalog.
- **Realtime Database workflows**
  - Inventory dashboard (add, read, update, delete) with instant UI refresh.
  - Chat room that streams new messages across devices immediately.
- **Performance lab**
  - Profile screen compares Realtime Database vs Firestore read speed for large datasets and documents recommended use cases.

## Running the app

1. Install Flutter 3.9+ and run `flutter pub get`.
2. Configure Firebase (web, Android, iOS) and ensure `firebase_options.dart` plus `google-services.json`/`GoogleService-Info.plist` are in place.
3. Enable Email/Password, Google Sign-in, Firestore, and Realtime Database in the Firebase console.
4. Start the app with `flutter run` and sign up to experience the booking + inventory flows.

## Performance notes

| Scenario | Realtime Database | Cloud Firestore |
| --- | --- | --- |
| Latency | Millisecond pushes, best for chat/inventory counters | Slightly higher but optimized for indexed queries |
| Data model | Hierarchical JSON, lightweight writes | Document/collection with composite indexes |
| Offline | Basic disk cache | Advanced offline cache and queries |
| Best for | Presence, chat, live counters | Analytics, bookings, carts, reporting |

The in-app performance card (Profile tab) lets you benchmark read times of both databases using your live data. Use the findings to guide which workload belongs to which Firebase database.
