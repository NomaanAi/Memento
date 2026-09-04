import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Provider was not initialized');
});

class PreferencesStorage {
  final SharedPreferences _prefs;

  PreferencesStorage(this._prefs);

  Future<void> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);
  
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> remove(String key) => _prefs.remove(key);
  Future<void> clear() => _prefs.clear();
}

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  return PreferencesStorage(ref.watch(sharedPreferencesProvider));
});
