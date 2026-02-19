import 'package:flutter/material.dart';
import '../data/country_data.dart';
import '../widgets/country_info_card.dart';
import '../models/country.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    CountryData.selectedCountry.addListener(_onSelectedCountryChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    CountryData.selectedCountry.removeListener(_onSelectedCountryChanged);
    super.dispose();
  }

  void _onSelectedCountryChanged() {
    if (CountryData.selectedCountry.value != null) {
      _searchController.text = CountryData.selectedCountry.value!.name;
    }
  }

  void _searchCountry() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Введите название страны';
      });
      CountryData.clearSelectedCountry();
      return;
    }

    final country = CountryData.findCountry(query);

    setState(() {
      if (country != null) {
        _errorMessage = '';
        CountryData.selectCountry(country);
      } else {
        _errorMessage = 'Страна не найдена';
        CountryData.clearSelectedCountry();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _errorMessage = '';
    });
    CountryData.clearSelectedCountry();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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
                    onPressed: _clearSearch,
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (_) => _searchCountry(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _searchCountry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
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

          Expanded(
            child: _errorMessage.isNotEmpty
                ? Center(
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
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
                : ValueListenableBuilder<Country?>(
              valueListenable: CountryData.selectedCountry,
              builder: (context, country, child) {
                if (country != null) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      CountryInfoCard(country: country),
                    ],
                  );
                }

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
              },
            ),
          ),
        ],
      ),
    );
  }
}