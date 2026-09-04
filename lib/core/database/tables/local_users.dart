import 'package:drift/drift.dart';

class LocalUsers extends Table {
  TextColumn get uid => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {uid};
}
