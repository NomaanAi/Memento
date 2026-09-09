import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'storage_adapter.dart';

class WebStorageAdapter implements StorageAdapter {
  late SharedPreferences _prefs;

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Simple in-memory representation backed by SharedPreferences for web demo
  List<Map<String, dynamic>> _getTable(String table) {
    final str = _prefs.getString('db_$table');
    if (str == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(str);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveTable(String table, List<Map<String, dynamic>> data) async {
    await _prefs.setString('db_$table', jsonEncode(data));
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    // Web mock doesn't support raw SQL execute, ignores for now.
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    List<Map<String, dynamic>> data = _getTable(table);

    // Very basic where filtering for simple cases like "userId = ?"
    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      if (where == 'userId = ?') {
        data = data.where((row) => row['userId'] == whereArgs.first).toList();
      } else if (where == 'id = ?') {
        data = data.where((row) => row['id'] == whereArgs.first).toList();
      }
      // Add more as needed for simple web mock
    }

    return data;
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final data = _getTable(table);
    data.add(Map<String, dynamic>.from(values));
    await _saveTable(table, data);
    return 1;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final data = _getTable(table);
    int count = 0;
    for (int i = 0; i < data.length; i++) {
      bool matches = true;
      if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
        matches = data[i]['id'] == whereArgs.first;
      }
      if (matches) {
        data[i] = {...data[i], ...values};
        count++;
      }
    }
    await _saveTable(table, data);
    return count;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final data = _getTable(table);
    final initialLen = data.length;
    if (where == 'id = ?' && whereArgs != null && whereArgs.isNotEmpty) {
      data.removeWhere((row) => row['id'] == whereArgs.first);
    }
    await _saveTable(table, data);
    return initialLen - data.length;
  }
}

StorageAdapter getStorageAdapter() => WebStorageAdapter();
