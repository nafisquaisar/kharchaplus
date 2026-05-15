# expense_tracker

A new Flutter project.

## Water Sync (Phase 11)

- Uses Firebase anonymous auth and Firestore collections under `users/{uid}/water_*`.
- Requires Firestore rules from `firestore.rules` to allow user-scoped access.
- Sync is local-first: data is saved to Isar and synced in the background when online.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
