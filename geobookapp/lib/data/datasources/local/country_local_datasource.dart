import '../../models/country_model.dart';
import '../../services/preferences_service.dart';

class CountryLocalDatasource {
  final PreferencesService _prefs;

  CountryLocalDatasource(this._prefs);

  /// Получение страны из кэша
  CountryModel? getCachedCountry(String query) {
    final cached = _prefs.getCachedCountry(query);
    if (cached != null) {
      return CountryModel.fromCache(cached);
    }
    return null;
  }

  /// Сохранение страны в кэш
  Future<void> cacheCountry(String query, CountryModel country) async {
    await _prefs.cacheCountry(query, country.toJson());
  }

  /// Очистка кэша
  Future<void> clearCache() async {
    await _prefs.clearCache();
  }

  /// История поисков
  List<String> getHistory() => _prefs.getHistory();

  Future<void> addToHistory(String name) => _prefs.addToHistory(name);

  Future<void> removeFromHistory(String name) => _prefs.removeFromHistory(name);

  Future<void> clearHistory() => _prefs.clearHistory();
}