class SoilData {
  final double ph;
  final double ec;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double temperature;
  final double humidity;
  final double fieldArea;
  final String cropType;

  SoilData({
    required this.ph,
    required this.ec,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.fieldArea,
    required this.cropType,
  });

  Map<String, dynamic> toJson() {
    return {
      'ph': ph,
      'ec': ec,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'temperature': temperature,
      'humidity': humidity,
      'field_area': fieldArea,
      'crop_type': cropType,
    };
  }
}
