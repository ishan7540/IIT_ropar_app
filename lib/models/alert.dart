import 'package:flutter/material.dart';
import 'package:aahar_app/services/weather_service.dart';

enum AlertSeverity { critical, warning, info }

class FarmAlert {
  final String title;
  final String titleHindi;
  final String description;
  final AlertSeverity severity;
  final IconData icon;
  final DateTime timestamp;

  FarmAlert({
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.severity,
    required this.icon,
    required this.timestamp,
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFBA1A1A);
      case AlertSeverity.warning:
        return const Color(0xFFF9A825);
      case AlertSeverity.info:
        return const Color(0xFF0277BD);
    }
  }

  Color get backgroundColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFFFDAD6);
      case AlertSeverity.warning:
        return const Color(0xFFFFF8E1);
      case AlertSeverity.info:
        return const Color(0xFFE1F5FE);
    }
  }

  /// Generate alerts dynamically from weather API data and NPK values.
  /// TODO: Replace mock NPK values with real data from Flask API.
  static Future<List<FarmAlert>> generateSmartAlerts() async {
    final List<FarmAlert> alerts = [];

    // ─── Weather-based alerts ───
    try {
      final weather = await WeatherService.fetchCurrentWeather();
      final rainfall = await WeatherService.fetchDailyRainfall();

      // Heat wave / high temperature alert
      if (weather.temperature >= 40) {
        alerts.add(FarmAlert(
          title: 'Heat Wave Alert',
          titleHindi: 'लू की चेतावनी — तुरंत फसल सुरक्षा करें',
          description:
              'Current temperature is ${weather.temperature.toStringAsFixed(1)}°C. '
              'Apply mulching, irrigate during early morning, and provide shade to nurseries.',
          severity: AlertSeverity.critical,
          icon: Icons.local_fire_department,
          timestamp: DateTime.now(),
        ));
      } else if (weather.temperature >= 36) {
        alerts.add(FarmAlert(
          title: 'High Temperature Warning',
          titleHindi: 'उच्च तापमान चेतावनी — सिंचाई जल्दी करें',
          description:
              'Temperature is ${weather.temperature.toStringAsFixed(1)}°C. '
              'Avoid spraying pesticides during midday. Irrigate in the evening.',
          severity: AlertSeverity.warning,
          icon: Icons.thermostat,
          timestamp: DateTime.now(),
        ));
      }

      // Major rainfall alert (check if any day has > 30mm)
      for (final day in rainfall) {
        if (day.rainfallMm >= 50) {
          alerts.add(FarmAlert(
            title: 'Heavy Rainfall Expected',
            titleHindi: 'भारी बारिश की संभावना — जल निकासी सुनिश्चित करें',
            description:
                '${day.rainfallMm.toStringAsFixed(1)} mm rainfall predicted on ${day.dayName} (${day.date.day}/${day.date.month}). '
                'Ensure proper drainage. Do not apply fertilizers before heavy rain.',
            severity: AlertSeverity.critical,
            icon: Icons.thunderstorm,
            timestamp: DateTime.now(),
          ));
          break; // Show only the first heavy rain alert
        } else if (day.rainfallMm >= 20) {
          alerts.add(FarmAlert(
            title: 'Moderate Rainfall Expected',
            titleHindi: 'मध्यम बारिश की संभावना — तैयारी करें',
            description:
                '${day.rainfallMm.toStringAsFixed(1)} mm rainfall predicted on ${day.dayName} (${day.date.day}/${day.date.month}). '
                'Good for crops but check field drainage.',
            severity: AlertSeverity.info,
            icon: Icons.umbrella,
            timestamp: DateTime.now(),
          ));
          break;
        }
      }

      // Low humidity alert
      if (weather.humidity < 25) {
        alerts.add(FarmAlert(
          title: 'Very Low Humidity',
          titleHindi: 'बहुत कम नमी — सिंचाई की जरूरत',
          description:
              'Humidity is only ${weather.humidity.toStringAsFixed(0)}%. '
              'Increase irrigation frequency and consider misting.',
          severity: AlertSeverity.warning,
          icon: Icons.water_drop_outlined,
          timestamp: DateTime.now(),
        ));
      }
    } catch (_) {
      // If weather API fails, skip weather alerts silently
    }

    // ─── NPK-based alerts (mock values for now) ───
    // TODO: Replace with real values from Flask /prediction API
    const currentN = 240.0;
    const optimalN = 280.0;
    const currentP = 18.0;
    const optimalP = 24.0;
    const currentK = 25.0;
    const optimalK = 30.0;

    if (currentN < optimalN * 0.85) {
      alerts.add(FarmAlert(
        title: 'Nitrogen (N) Level Low',
        titleHindi: 'नाइट्रोजन का स्तर कम — यूरिया डालें',
        description:
            'Current: ${currentN.toStringAsFixed(0)} kg/ha (Optimal: ${optimalN.toStringAsFixed(0)} kg/ha). '
            'Apply 87 kg Urea per acre in split doses for best results.',
        severity: AlertSeverity.critical,
        icon: Icons.science,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ));
    }

    if (currentP < optimalP * 0.85) {
      alerts.add(FarmAlert(
        title: 'Phosphorus (P) Level Low',
        titleHindi: 'फास्फोरस कम है — DAP डालें',
        description:
            'Current: ${currentP.toStringAsFixed(0)} kg/ha (Optimal: ${optimalP.toStringAsFixed(0)} kg/ha). '
            'Apply DAP at sowing time for maximum root development.',
        severity: AlertSeverity.warning,
        icon: Icons.science_outlined,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ));
    }

    if (currentK < optimalK * 0.85) {
      alerts.add(FarmAlert(
        title: 'Potassium (K) Level Low',
        titleHindi: 'पोटेशियम कम है — MOP डालें',
        description:
            'Current: ${currentK.toStringAsFixed(0)} kg/ha (Optimal: ${optimalK.toStringAsFixed(0)} kg/ha). '
            'Apply MOP fertilizer to improve crop resistance and quality.',
        severity: AlertSeverity.warning,
        icon: Icons.eco,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ));
    }

    // If no alerts were generated, add a positive status
    if (alerts.isEmpty) {
      alerts.add(FarmAlert(
        title: 'All Clear — Farm Healthy',
        titleHindi: 'सब ठीक है — खेत स्वस्थ है',
        description:
            'No major weather or nutrient alerts at this time. '
            'Your farm conditions are within optimal ranges.',
        severity: AlertSeverity.info,
        icon: Icons.check_circle_outline,
        timestamp: DateTime.now(),
      ));
    }

    return alerts;
  }
}
