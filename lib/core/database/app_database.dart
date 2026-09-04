import 'package:drift/drift.dart';
import 'connection/database_connection.dart';
import 'tables/local_users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [LocalUsers], daos: [/* TODO: Add DAOs */])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Implement migrations
      },
    );
  }
}
