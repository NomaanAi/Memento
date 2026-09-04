import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor createDatabaseConnection() {
  return WebDatabase('memento_db');
}
