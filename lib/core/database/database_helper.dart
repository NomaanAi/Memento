import 'package:memento/core/storage/storage_adapter.dart';
import 'package:memento/core/storage/storage.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  StorageAdapter? _adapter;
  Future<StorageAdapter>? _initFuture;

  Future<StorageAdapter> get database async {
    if (_adapter != null) return _adapter!;

    _initFuture ??= _init();
    return await _initFuture!;
  }

  Future<StorageAdapter> _init() async {
    final adapter = getStorageAdapter();
    await adapter.initialize();
    _adapter = adapter;
    return adapter;
  }
}
