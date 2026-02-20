class AppConstants {
  // API
  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const Duration apiTimeout = Duration(seconds: 10);

  // Shared Preferences keys
  static const String keyHistory = 'search_history';
  static const String keyCachedCountries = 'cached_countries';

  // UI
  static const String appTitle = 'Географический справочник';
  static const int maxHistoryItems = 10;
}