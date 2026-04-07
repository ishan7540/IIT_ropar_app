import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to fetch weather data from OpenWeatherMap API.
///
/// Currently hardcoded to Patiala, Punjab.
/// TODO: Replace [latitude] and [longitude] with dynamic farmer location
/// to get location-specific rainfall data.
class WeatherService {
  static const String _apiKey = 'e2145fe464ca609566f440966b5caa4c';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Patiala, Punjab coordinates
  // TODO: Replace with dynamic lat/lon from farmer profile or GPS
  static double latitude = 30.3398;
  static double longitude = 76.3869;

  /// Fetches 5-day / 3-hour forecast and aggregates daily rainfall (mm).
  /// Returns a list of [DailyRainfall] for the next 5+ days.
  static Future<List<DailyRainfall>> fetchDailyRainfall() async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _aggregateDailyRainfall(data);
      } else {
        throw WeatherApiException(
          'API returned status ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Network error: $e');
    }
  }

  /// Aggregates 3-hour interval data into daily rainfall totals.
  static List<DailyRainfall> _aggregateDailyRainfall(
      Map<String, dynamic> data) {
    final list = data['list'] as List<dynamic>;
    final Map<String, double> dailyTotals = {};
    final Map<String, DateTime> dailyDates = {};

    for (final entry in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        (entry['dt'] as int) * 1000,
      );
      final dayKey =
          '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

      // Rain volume in mm (3-hour interval)
      double rain = 0.0;
      if (entry['rain'] != null && entry['rain']['3h'] != null) {
        rain = (entry['rain']['3h'] as num).toDouble();
      }

      dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0.0) + rain;
      dailyDates[dayKey] ??= dt;
    }

    // Convert to sorted list
    final sortedKeys = dailyTotals.keys.toList()..sort();

    return sortedKeys.map((key) {
      return DailyRainfall(
        date: dailyDates[key]!,
        rainfallMm: double.parse(dailyTotals[key]!.toStringAsFixed(1)),
      );
    }).toList();
  }

  /// Fetches current weather summary for the location.
  static Future<CurrentWeather> fetchCurrentWeather() async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeather.fromJson(data);
      } else {
        throw WeatherApiException(
          'API returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Network error: $e');
    }
  }
}

/// Daily rainfall data point.
class DailyRainfall {
  final DateTime date;
  final double rainfallMm;

  DailyRainfall({required this.date, required this.rainfallMm});

  /// Day name abbreviation (Mon, Tue, etc.)
  String get dayName {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  /// Hindi day name
  String get dayNameHindi {
    const days = ['सोम', 'मंगल', 'बुध', 'गुरु', 'शुक्र', 'शनि', 'रवि'];
    return days[date.weekday - 1];
  }
}

/// Current weather snapshot.
class CurrentWeather {
  final double temperature;
  final double humidity;
  final String description;
  final double? rainLastHour;

  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.description,
    this.rainLastHour,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      rainLastHour: json['rain'] != null
          ? (json['rain']['1h'] as num?)?.toDouble()
          : null,
    );
  }
}

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => 'WeatherApiException: $message';
}
