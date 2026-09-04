import 'package:drift/drift.dart';

QueryExecutor createDatabaseConnection() {
  throw UnsupportedError(
    'No suitable database implementation was found on this platform.',
  );
}
