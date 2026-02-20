import '../entities/country.dart';

abstract class CountryRepository {
  /// Поиск страны по названию (сначала кэш, затем сеть)
  Future<Country?> findCountry(String query, {bool forceRefresh = false});

  /// Получение истории поисков
  List<String> getSearchHistory();

  /// Добавление в историю
  Future<void> addToHistory(String countryName);

  /// Удаление из истории
  Future<void> removeFromHistory(String countryName);

  /// Очистка истории
  Future<void> clearHistory();

  /// Очистка кэша
  Future<void> clearCache();
}