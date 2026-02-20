import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Инициализация сервиса
  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // ===== История поисков =====

  List<String> getHistory() {
    return _prefs.getStringList(AppConstants.keyHistory) ?? [];
  }

  Future<void> addToHistory(String countryName) async {
    final history = getHistory();
    history.removeWhere((name) => name.toLowerCase() == countryName.toLowerCase());
    history.insert(0, countryName);

    if (history.length > AppConstants.maxHistoryItems) {
      history.removeLast();
    }

    await _prefs.setStringList(AppConstants.keyHistory, history);
  }

  Future<void> removeFromHistory(String countryName) async {
    final history = getHistory();
    history.removeWhere((name) => name.toLowerCase() == countryName.toLowerCase());
    await _prefs.setStringList(AppConstants.keyHistory, history);
  }

  Future<void> clearHistory() async {
    await _prefs.remove(AppConstants.keyHistory);
  }

  // ===== Кэш стран =====

  Future<void> cacheCountry(String query, Map<String, dynamic> data) async {
    final cache = await _getCachedCountries();
    cache[query.toLowerCase()] = data;
    await _prefs.setString(
      AppConstants.keyCachedCountries,
      json.encode(cache),
    );
  }

  Map<String, dynamic>? getCachedCountry(String query) {
    final cache = _getCachedCountriesSync();
    return cache[query.toLowerCase()];
  }

  Future<void> clearCache() async {
    await _prefs.remove(AppConstants.keyCachedCountries);
  }

  // ===== Приватные методы =====

  Future<Map<String, dynamic>> _getCachedCountries() async {
    final jsonStr = _prefs.getString(AppConstants.keyCachedCountries);
    if (jsonStr == null) return {};
    try {
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Map<String, dynamic> _getCachedCountriesSync() {
    final jsonStr = _prefs.getString(AppConstants.keyCachedCountries);
    if (jsonStr == null) return {};
    try {
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}