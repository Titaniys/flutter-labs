import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/country_view_model.dart';
import 'search_screen.dart';
import 'history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Устанавливаем колбэк для переключения на главную
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CountryViewModel>().setNavigateToHomeCallback(_goToHome);
    });
  }

  void _goToHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SearchScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem('Главная', 0, Icons.home_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNavItem('История', 1, Icons.history),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, int index, IconData icon) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade300 : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: isSelected ? null : Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}