import 'package:flutter/material.dart';

class FieldParameter {
  final String name;
  final String nameHindi;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  FieldParameter({
    required this.name,
    required this.nameHindi,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  static List<FieldParameter> mockList() {
    return [
      FieldParameter(
        name: 'Temperature',
        nameHindi: 'तापमान',
        value: '32',
        unit: '°C',
        icon: Icons.thermostat,
        color: const Color(0xFFE65100),
      ),
      FieldParameter(
        name: 'Humidity',
        nameHindi: 'आर्द्रता',
        value: '45',
        unit: '%',
        icon: Icons.water_drop,
        color: const Color(0xFF0277BD),
      ),
      FieldParameter(
        name: 'Rainfall',
        nameHindi: 'वर्षा',
        value: '0',
        unit: 'mm',
        icon: Icons.grain,
        color: const Color(0xFF1565C0),
      ),
      FieldParameter(
        name: 'Wind Speed',
        nameHindi: 'हवा की गति',
        value: '12',
        unit: 'km/h',
        icon: Icons.air,
        color: const Color(0xFF00838F),
      ),
      FieldParameter(
        name: 'Wet Bulb',
        nameHindi: 'वेट बल्ब',
        value: '24',
        unit: '°C',
        icon: Icons.dew_point,
        color: const Color(0xFF00695C),
      ),
      FieldParameter(
        name: 'Pressure',
        nameHindi: 'दबाव',
        value: '1013',
        unit: 'hPa',
        icon: Icons.speed,
        color: const Color(0xFF4527A0),
      ),
      FieldParameter(
        name: 'NDVI',
        nameHindi: 'वनस्पति सूचकांक',
        value: '0.72',
        unit: '',
        icon: Icons.eco,
        color: const Color(0xFF2E7D32),
      ),
      FieldParameter(
        name: 'EVI',
        nameHindi: 'संवर्धित वनस्पति',
        value: '0.45',
        unit: '',
        icon: Icons.forest,
        color: const Color(0xFF388E3C),
      ),
      FieldParameter(
        name: 'NDWI',
        nameHindi: 'जल सूचकांक',
        value: '0.12',
        unit: '',
        icon: Icons.waves,
        color: const Color(0xFF0288D1),
      ),
      FieldParameter(
        name: 'Soil Moisture',
        nameHindi: 'मिट्टी नमी',
        value: '22',
        unit: '%',
        icon: Icons.opacity,
        color: const Color(0xFF5D4037),
      ),
      FieldParameter(
        name: 'Radiation',
        nameHindi: 'विकिरण',
        value: '850',
        unit: 'W/m²',
        icon: Icons.wb_sunny,
        color: const Color(0xFFFF8F00),
      ),
      FieldParameter(
        name: 'Soil Temp',
        nameHindi: 'मिट्टी तापमान',
        value: '26',
        unit: '°C',
        icon: Icons.thermostat_auto,
        color: const Color(0xFF6D4C41),
      ),
      FieldParameter(
        name: 'Leaf Wetness',
        nameHindi: 'पत्ती का गीलापन',
        value: 'Low',
        unit: '',
        icon: Icons.grass,
        color: const Color(0xFF558B2F),
      ),
      FieldParameter(
        name: 'VPD',
        nameHindi: 'वाष्प दबाव',
        value: '1.2',
        unit: 'kPa',
        icon: Icons.cloud,
        color: const Color(0xFF546E7A),
      ),
    ];
  }
}
