# Memento

## Overview
Memento is an offline-first personal productivity and knowledge-management application that allows users to manage projects, tasks, notes, documents, journals, goals, schedules, reminders, and productivity analytics from one centralized application.

## Features
- Offline-first architecture
- Projects and Tasks management
- Notes, Documents, and Journals
- Goals and Scheduling
- Analytics and Search
- Cloud Synchronization via Firebase

## Technology Stack
- **Framework**: Flutter / Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Database**: SQLite / Drift
- **Cloud/Backend**: Firebase (Auth, Firestore, Storage, Messaging, Crashlytics, Analytics)
- **Networking**: Dio
- **Architecture**: Clean Architecture / Feature-first

## Architecture
Data flows in the following pattern:
Local Database (Drift) <-> Repository <-> Domain <-> Riverpod <-> UI

The repository decides whether to fetch from the local database or Firebase/REST API based on network availability and sync status. The UI only communicates with the repository through Riverpod providers and does not interact with the data sources directly.

## Project Structure
- `lib/core/`: Common components, theme, routing, error handling, network interceptors, storage interfaces.
- `lib/features/`: Feature modules containing `data`, `domain`, and `presentation` layers.
- `assets/`: Images, icons, fonts.

## Setup Instructions

### Flutter Version
Ensure you have the latest stable version of Flutter installed.

### Firebase Setup
1. Create a Firebase project in the console.
2. Install the FlutterFire CLI.
3. Run `flutterfire configure` to generate `firebase_options.dart`.
4. The application currently has Firebase initialization wrapped in a try-catch to prevent crashing if `firebase_options.dart` is missing.

## Running the Application
`flutter run`

## Testing
`flutter test` (Unit and Widget tests)
`flutter test integration_test` (Integration tests)

## Build Instructions
Generate required code (Freezed, Drift, JSON Serializable) using:
`dart run build_runner build --delete-conflicting-outputs`

## Future Roadmap
- [ ] Implement robust conflict resolution for cloud synchronization.
- [ ] Implement full authentication UI.
- [ ] Implement Projects and Tasks CRUD operations.
- [ ] Add global search.
