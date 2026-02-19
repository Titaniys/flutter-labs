import 'package:flutter/foundation.dart';
import '../models/country.dart';

class CountryData {
  static final List<Country> _history = [];
  static final ValueNotifier<Country?> selectedCountry = ValueNotifier<Country?>(null);

  static final Map<String, Country> _countries = {
    'россия': const Country(
      name: 'Россия',
      capital: 'Москва',
      flag: '🇷🇺',
      population: '146 млн',
      languages: 'Русский',
      currency: 'Рубль (RUB)',
    ),
    'сша': const Country(
      name: 'США',
      capital: 'Вашингтон',
      flag: '🇺',
      population: '331 млн',
      languages: 'Английский',
      currency: 'Доллар США (USD)',
    ),
    'китай': const Country(
      name: 'Китай',
      capital: 'Пекин',
      flag: '🇨🇳',
      population: '1.4 млрд',
      languages: 'Китайский',
      currency: 'Юань (CNY)',
    ),
    'германия': const Country(
      name: 'Германия',
      capital: 'Берлин',
      flag: '🇩',
      population: '83 млн',
      languages: 'Немецкий',
      currency: 'Евро (EUR)',
    ),
    'франция': const Country(
      name: 'Франция',
      capital: 'Париж',
      flag: '🇫',
      population: '67 млн',
      languages: 'Французский',
      currency: 'Евро (EUR)',
    ),
    'япония': const Country(
      name: 'Япония',
      capital: 'Токио',
      flag: '🇯🇵',
      population: '126 млн',
      languages: 'Японский',
      currency: 'Иена (JPY)',
    ),
    'бразилия': const Country(
      name: 'Бразилия',
      capital: 'Бразилиа',
      flag: '🇧🇷',
      population: '212 млн',
      languages: 'Португальский',
      currency: 'Реал (BRL)',
    ),
    'индия': const Country(
      name: 'Индия',
      capital: 'Нью-Дели',
      flag: '🇮🇳',
      population: '1.38 млрд',
      languages: 'Хинди, Английский',
      currency: 'Рупия (INR)',
    ),
  };

  static Country? findCountry(String query) {
    final normalizedQuery = query.toLowerCase().trim();
    return _countries[normalizedQuery];
  }

  static List<Country> get history => List.unmodifiable(_history);

  static void addToHistory(Country country) {
    _history.removeWhere((c) => c.name == country.name);
    _history.insert(0, country);
    if (_history.length > 10) {
      _history.removeLast();
    }
  }

  static void removeFromHistory(Country country) {
    _history.removeWhere((c) => c.name == country.name);
  }

  static void clearHistory() {
    _history.clear();
  }

  static void selectCountry(Country country) {
    selectedCountry.value = country;
    addToHistory(country);
  }

  static void clearSelectedCountry() {
    selectedCountry.value = null;
  }
}