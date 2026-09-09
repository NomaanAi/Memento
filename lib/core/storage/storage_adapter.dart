abstract class StorageAdapter {
  Future<void> initialize();
  Future<void> execute(String sql, [List<Object?>? arguments]);
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  });
  Future<int> insert(String table, Map<String, Object?> values);
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs});
}
