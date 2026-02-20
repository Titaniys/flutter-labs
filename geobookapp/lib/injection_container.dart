import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/api_client.dart';
import 'data/datasources/local/country_local_datasource.dart';
import 'data/datasources/remote/country_remote_datasource.dart';
import 'data/repositories/country_repository_impl.dart';
import 'data/services/preferences_service.dart';
import 'domain/repositories/country_repository.dart';
import 'presentation/view_models/country_view_model.dart';

class InjectionContainer {
  // Singleton instance
  static final _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  // Services
  late final PreferencesService preferencesService;
  late final ApiClient apiClient;

  // Data sources
  late final CountryLocalDatasource localDatasource;
  late final CountryRemoteDatasource remoteDatasource;

  // Repository
  late final CountryRepository countryRepository;

  // ViewModels
  late final CountryViewModel countryViewModel;

  /// Инициализация всех зависимостей
  Future<void> init() async {
    // Services
    preferencesService = await PreferencesService.init();
    apiClient = ApiClient();

    // Data sources
    localDatasource = CountryLocalDatasource(preferencesService);
    remoteDatasource = CountryRemoteDatasource(apiClient);

    // Repository
    countryRepository = CountryRepositoryImpl(
      local: localDatasource,
      remote: remoteDatasource,
    );

    // ViewModel
    countryViewModel = CountryViewModel(repository: countryRepository);
  }

  /// Очистка ресурсов
  void dispose() {
    apiClient.dispose();
  }
}