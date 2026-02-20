import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../core/utils/logger.dart';

class CountryInfoCard extends StatelessWidget {
  final Country country;
  final String? flagUrl;

  const CountryInfoCard({
    super.key,
    required this.country,
    this.flagUrl,
  });

  @override
  Widget build(BuildContext context) {
    Logger.debug('CountryInfoCard: flagUrl = $flagUrl');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildFlag(),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  country.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Столица', country.capital, Icons.location_city),
          _buildDivider(),
          _buildInfoRow('Население', country.population, Icons.people),
          _buildDivider(),
          _buildInfoRow('Языки', country.languages, Icons.language),
          _buildDivider(),
          _buildInfoRow('Валюта', country.currency, Icons.attach_money),
          if (country.region != null) ...[
            _buildDivider(),
            _buildInfoRow('Регион', country.region!, Icons.public),
          ],
        ],
      ),
    );
  }

  Widget _buildFlag() {
    Logger.debug('_buildFlag called with URL: $flagUrl');

    if (flagUrl != null && flagUrl!.isNotEmpty) {
      Logger.debug('Loading flag from network: $flagUrl');

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          flagUrl!,
          width: 80,
          height: 60,
          fit: BoxFit.cover,
          headers: {
            'User-Agent': 'Flutter App',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              Logger.debug('Flag loaded successfully');
              return child;
            }
            Logger.debug('Flag loading progress: ${loadingProgress.cumulativeBytesLoaded}');
            return Container(
              width: 80,
              height: 60,
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            Logger.error('Error loading flag: $error');
            Logger.error('Stack trace: $stackTrace');
            return _buildFlagPlaceholder();
          },
        ),
      );
    }

    Logger.debug('Using emoji flag: ${country.flag}');
    return Text(country.flag, style: const TextStyle(fontSize: 48));
  }

  Widget _buildFlagPlaceholder() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.flag, size: 32, color: Colors.grey),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(color: Colors.grey.shade200, height: 1);
}