import '../../domain/entities/country.dart';
import '../../core/utils/logger.dart';

class CountryModel extends Country {
  final String? flagUrl;

  const CountryModel({
    required super.name,
    required super.capital,
    required super.flag,
    required super.population,
    required super.languages,
    required super.currency,
    super.region,
    super.subregion,
    super.lat,
    super.lng,
    this.flagUrl,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final name = json['name']['common'] as String? ?? 'Неизвестно';
    final capitalList = json['capital'] as List<dynamic>?;
    final capital = capitalList?.isNotEmpty == true
        ? capitalList![0] as String
        : 'Неизвестно';

    // Получаем URL флага - ИСПОЛЬЗУЕМ PNG ВМЕСТО SVG!
    final flags = json['flags'] as Map<String, dynamic>?;
    Logger.debug('Parsing flags for $name: $flags');

    // Сначала пробуем PNG, затем SVG (как запасной вариант)
    final flagPng = flags?['png'] as String?;
    final flagSvg = flags?['svg'] as String?;
    final flagEmoji = flags?['emoji'] as String? ?? '🏳️';

    // Используем PNG, если есть, иначе SVG
    String? flagUrl;
    if (flagPng != null && flagPng.isNotEmpty) {
      // Заменяем URL на PNG большего размера если нужно
      flagUrl = flagPng;
      Logger.debug('Using PNG flag for $name: $flagUrl');
    } else if (flagSvg != null && flagSvg.isNotEmpty) {
      flagUrl = flagSvg;
      Logger.debug('Using SVG flag for $name: $flagUrl (может не отобразиться)');
    }

    final population = json['population'] as int?;
    final populationStr = population != null
        ? _formatPopulation(population)
        : 'Неизвестно';

    final languagesMap = json['languages'] as Map<String, dynamic>?;
    final languages = languagesMap?.values.cast<String>().join(', ') ?? 'Неизвестно';

    final currencies = json['currencies'] as Map<String, dynamic>?;
    final currency = _formatCurrency(currencies);

    final region = json['region'] as String?;
    final subregion = json['subregion'] as String?;

    final latlng = json['latlng'] as List<dynamic>?;
    final lat = latlng?.length == 2 ? latlng![0] as double? : null;
    final lng = latlng?.length == 2 ? latlng![1] as double? : null;

    return CountryModel(
      name: name,
      capital: capital,
      flag: flagEmoji,
      population: populationStr,
      languages: languages,
      currency: currency,
      region: region,
      subregion: subregion,
      lat: lat,
      lng: lng,
      flagUrl: flagUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capital': capital,
      'flag': flag,
      'flagUrl': flagUrl,
      'population': population,
      'languages': languages,
      'currency': currency,
      'region': region,
      'subregion': subregion,
      'lat': lat,
      'lng': lng,
    };
  }

  factory CountryModel.fromCache(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] as String,
      capital: json['capital'] as String,
      flag: json['flag'] as String,
      population: json['population'] as String,
      languages: json['languages'] as String,
      currency: json['currency'] as String,
      region: json['region'] as String?,
      subregion: json['subregion'] as String?,
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
      flagUrl: json['flagUrl'] as String?,
    );
  }

  static String _formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(2)} млрд';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)} млн';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)} тыс';
    }
    return population.toString();
  }

  static String _formatCurrency(Map<String, dynamic>? currencies) {
    if (currencies == null || currencies.isEmpty) return 'Неизвестно';

    final first = currencies.entries.first;
    final name = first.value['name'] as String? ?? '';
    final code = first.value['code'] as String? ?? '';
    final symbol = first.value['symbol'] as String? ?? '';

    if (name.isNotEmpty && code.isNotEmpty) {
      return '$name ($code)';
    } else if (symbol.isNotEmpty) {
      return symbol;
    }
    return name.isNotEmpty ? name : (code.isNotEmpty ? code : 'Неизвестно');
  }
}