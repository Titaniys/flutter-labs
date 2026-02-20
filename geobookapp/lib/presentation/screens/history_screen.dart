import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/country_view_model.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _onCountrySelected(String countryName) {
    context.read<CountryViewModel>().selectFromHistory(countryName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открыта: $countryName'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onRemoveFromHistory(String countryName) {
    context.read<CountryViewModel>().removeFromHistory(countryName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$countryName удалена'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () {
            context.read<CountryViewModel>().addToHistory(countryName);
          },
        ),
      ),
    );
  }

  void _onClearHistory() {
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
              context.read<CountryViewModel>().clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('История очищена')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryViewModel>(
      builder: (context, viewModel, child) {
        final history = viewModel.history;

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
                        onPressed: _onClearHistory,
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Очистить историю',
                        color: Colors.red,
                      ),
                  ],
                ),
              ),

              Expanded(
                child: history.isEmpty
                    ? _buildEmptyState()
                    : _buildHistoryList(history),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
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
          SizedBox(height: 8),
          Text(
            'Найдите страну на главном экране',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<String> history) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final countryName = history[index];

        return HistoryItem(
          countryName: countryName,
          country: null,
          onDelete: () => _onRemoveFromHistory(countryName),
          onTap: () => _onCountrySelected(countryName),
        );
      },
    );
  }
}