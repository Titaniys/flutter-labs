import 'package:flutter/foundation.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';

class CountryViewModel extends ChangeNotifier {
  final CountryRepository _repository;

  Country? _selectedCountry;
  String? _errorMessage;
  bool _isLoading = false;
  List<String> _history = [];

  // Колбэк для переключения вкладки на главную
  VoidCallback? _onNavigateToHome;

  CountryViewModel({required CountryRepository repository})
      : _repository = repository;

  // ===== Getters =====
  Country? get selectedCountry => _selectedCountry;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<String> get history => List.unmodifiable(_history);

  // ===== Public methods =====

  /// Установить колбэк для навигации
  void setNavigateToHomeCallback(VoidCallback callback) {
    _onNavigateToHome = callback;
  }

  Future<void> searchCountry(String query) async {
    if (query.trim().isEmpty) {
      _setError('Введите название страны');
      return;
    }

    _setLoading(true);

    try {
      final country = await _repository.findCountry(query);

      if (country != null) {
        _selectedCountry = country;
        _errorMessage = null;
        await _loadHistory();
      } else {
        _setError('Страна не найдена');
      }
    } catch (e) {
      _setError(_mapError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectFromHistory(String countryName) async {
    // Сначала переключаем на главную вкладку
    if (_onNavigateToHome != null) {
      _onNavigateToHome!();
    }
    // Затем загружаем данные
    await searchCountry(countryName);
  }

  Future<void> removeFromHistory(String countryName) async {
    await _repository.removeFromHistory(countryName);
    await _loadHistory();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    _history = [];
    notifyListeners();
  }

  Future<void> addToHistory(String countryName) async {
    await _repository.addToHistory(countryName);
    await _loadHistory();
  }

  void clearSelection() {
    _selectedCountry = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> init() async {
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = _repository.getSearchHistory();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _selectedCountry = null;
    notifyListeners();
  }

  String _mapError(dynamic error) {
    if (error.toString().contains('Нет подключения')) {
      return 'Проверьте подключение к интернету';
    }
    if (error.toString().contains('не найдена')) {
      return 'Страна не найдена. Попробуйте ввести название на английском';
    }
    return 'Произошла ошибка. Попробуйте позже';
  }

  @override
  void dispose() {
    super.dispose();
  }
}