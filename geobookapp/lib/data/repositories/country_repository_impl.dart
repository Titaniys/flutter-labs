import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/local/country_local_datasource.dart';
import '../datasources/remote/country_remote_datasource.dart';
import '../models/country_model.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryLocalDatasource _local;
  final CountryRemoteDatasource _remote;

  CountryRepositoryImpl({
    required CountryLocalDatasource local,
    required CountryRemoteDatasource remote,
  })  : _local = local,
        _remote = remote;

  @override
  Future<Country?> findCountry(String query, {bool forceRefresh = false}) async {
    final normalizedQuery = query.trim().toLowerCase();

    // Если не форсируем обновление, пробуем кэш
    if (!forceRefresh) {
      final cached = _local.getCachedCountry(normalizedQuery);
      if (cached != null) {
        return cached;
      }
    }

    try {
      // Запрос к API
      final country = await _remote.fetchCountry(query);

      // Кэшируем результат
      await _local.cacheCountry(normalizedQuery, country);

      // Добавляем в историю
      await _local.addToHistory(country.name);

      return country;
    } catch (e) {
      // Если сеть недоступна, возвращаем кэш (если есть)
      final cached = _local.getCachedCountry(normalizedQuery);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  List<String> getSearchHistory() => _local.getHistory();

  @override
  Future<void> addToHistory(String countryName) =>
      _local.addToHistory(countryName);

  @override
  Future<void> removeFromHistory(String countryName) =>
      _local.removeFromHistory(countryName);

  @override
  Future<void> clearHistory() => _local.clearHistory();

  @override
  Future<void> clearCache() => _local.clearCache();

  void dispose() => _remote.dispose();
}