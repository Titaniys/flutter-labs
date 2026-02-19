import 'package:flutter/material.dart';
import '../data/country_data.dart';
import '../widgets/history_item.dart';
import '../models/country.dart';

class HistoryScreen extends StatefulWidget {
  final Function(Country)? onCountrySelected;

  const HistoryScreen({super.key, this.onCountrySelected});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _onCountrySelected(Country country) {
    // Устанавливаем выбранную страну
    CountryData.selectCountry(country);

    // Показываем уведомление, что страна выбрана
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Выбрана страна: ${country.name}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeFromHistory(Country country) {
    setState(() {
      CountryData.removeFromHistory(country);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${country.name} удалена из истории'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () {
            setState(() {
              CountryData.addToHistory(country);
            });
          },
        ),
      ),
    );
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю?'),
        content: const Text('Все записи будут удалены безвозвратно'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                CountryData.clearHistory();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('История очищена')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = CountryData.history;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Географический справочник',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (history.isNotEmpty)
                  IconButton(
                    onPressed: _clearHistory,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Очистить историю',
                  ),
              ],
            ),
          ),

          Expanded(
            child: history.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'История пуста',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final country = history[index];
                return HistoryItem(
                  country: country,
                  onDelete: () => _removeFromHistory(country),
                  onTap: () => _onCountrySelected(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}