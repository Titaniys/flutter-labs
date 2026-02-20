import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/country_view_model.dart';
import '../widgets/country_info_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<CountryViewModel>().searchCountry(query);
    }
  }

  void _onClear() {
    _searchController.clear();
    context.read<CountryViewModel>().clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryViewModel>(
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Column(
            children: [
              // Заголовок
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Географический справочник',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Поле поиска
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Введите страну для поиска',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: _onClear,
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onSubmitted: (_) => _onSearchSubmitted(),
                  ),
                ),
              ),

              // Кнопка поиска
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _onSearchSubmitted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Найти',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Контент
              Expanded(
                child: _buildContent(viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(CountryViewModel viewModel) {
    // Ошибка
    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Страна найдена
    if (viewModel.selectedCountry != null) {
      final selectedCountry = viewModel.selectedCountry!;

      // Получаем flagUrl через dynamic (так как CountryModel имеет это поле)
      String? flagUrl;
      try {
        final dynamic dyn = selectedCountry;
        flagUrl = dyn.flagUrl as String?;
      } catch (_) {
        // Игнорируем ошибки
      }

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          CountryInfoCard(
            country: selectedCountry,
            flagUrl: flagUrl,
          ),
        ],
      );
    }

    // Пустое состояние
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Введите название страны\nдля поиска информации',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}