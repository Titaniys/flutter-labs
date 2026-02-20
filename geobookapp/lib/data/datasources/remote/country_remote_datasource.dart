import '../../../core/network/api_client.dart';
import '../../models/country_model.dart';

class CountryRemoteDatasource {
  final ApiClient _apiClient;

  CountryRemoteDatasource(this._apiClient);

  /// Запрос страны из API (полное совпадение)
  Future<CountryModel> fetchCountry(String name) async {
    final result = await _apiClient.get('/name/$name?fullText=true');

    if (result is List<dynamic>) {
      if (result.isNotEmpty) {
        final first = result[0];
        if (first is Map<String, dynamic>) {
          return CountryModel.fromJson(first);
        }
      }
      throw ApiException('Страна не найдена', code: 404);
    } else if (result is Map<String, dynamic>) {
      return CountryModel.fromJson(result);
    }

    throw ApiException('Некорректный формат ответа от сервера');
  }

  /// Поиск с частичным совпадением (fallback)
  Future<List<CountryModel>> searchCountries(String query) async {
    final result = await _apiClient.get('/name/$query');

    if (result is List<dynamic>) {
      final countries = <CountryModel>[];
      for (final item in result) {
        if (item is Map<String, dynamic>) {
          try {
            countries.add(CountryModel.fromJson(item));
          } catch (e) {
            // Пропускаем некорректные записи
            continue;
          }
        }
      }
      return countries;
    } else if (result is Map<String, dynamic>) {
      try {
        return [CountryModel.fromJson(result)];
      } catch (e) {
        return [];
      }
    }

    return [];
  }

  void dispose() => _apiClient.dispose();
}