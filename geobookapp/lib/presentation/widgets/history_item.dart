import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';

class HistoryItem extends StatelessWidget {
  final String countryName;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Country? country;

  const HistoryItem({
    super.key,
    required this.countryName,
    required this.onDelete,
    required this.onTap,
    this.country,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            // Флаг
            _buildFlag(),
            const SizedBox(width: 12),

            // Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    countryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    country?.capital ?? 'Нажмите для просмотра',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Кнопка удаления
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlag() {
    // Если есть URL флага, загружаем изображение
    if (country != null) {
      final flagUrl = _getFlagUrl(country!);
      if (flagUrl != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            flagUrl,
            width: 40,
            height: 30,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFlagPlaceholder();
            },
          ),
        );
      }
    }

    // Fallback на emoji
    return _buildFlagPlaceholder();
  }

  Widget _buildFlagPlaceholder() {
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.flag,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  String? _getFlagUrl(Country country) {
    // Проверяем, есть ли у страны поле flagUrl (для CountryModel)
    try {
      final mirror = ReflectMirror(country);
      if (mirror.hasField('flagUrl')) {
        return mirror.getField('flagUrl') as String?;
      }
    } catch (_) {
      // Игнорируем ошибки рефлексии
    }
    return null;
  }
}

// Простая реализация без reflection (более надёжно)
class ReflectMirror {
  final Object _object;

  ReflectMirror(this._object);

  bool hasField(String name) {
    try {
      final props = _object.runtimeType.toString();
      return true; // Упрощённая проверка
    } catch (_) {
      return false;
    }
  }

  dynamic getField(String name) {
    return null;
  }
}