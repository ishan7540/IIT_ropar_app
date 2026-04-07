enum NutrientStatus { low, optimal, high }

class NutrientReading {
  final String name;
  final String nameHindi;
  final double current;
  final double optimal;
  final NutrientStatus status;
  final String unit;

  NutrientReading({
    required this.name,
    required this.nameHindi,
    required this.current,
    required this.optimal,
    required this.status,
    this.unit = 'kg/ha',
  });

  double get percentage => (current / optimal * 100).clamp(0, 150);
}

class FertilizerRecommendation {
  final String name;
  final String nameHindi;
  final double amountKg;
  final String target;

  FertilizerRecommendation({
    required this.name,
    required this.nameHindi,
    required this.amountKg,
    required this.target,
  });
}

class NpkResult {
  final NutrientReading nitrogen;
  final NutrientReading phosphorus;
  final NutrientReading potassium;
  final List<FertilizerRecommendation> fertilizers;
  final String expertTip;
  final DateTime lastUpdated;
  final String sector;

  NpkResult({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.fertilizers,
    required this.expertTip,
    required this.lastUpdated,
    required this.sector,
  });

  static NpkResult mock() {
    return NpkResult(
      nitrogen: NutrientReading(
        name: 'Nitrogen (N)',
        nameHindi: 'नाइट्रोजन',
        current: 240,
        optimal: 280,
        status: NutrientStatus.low,
      ),
      phosphorus: NutrientReading(
        name: 'Phosphorus (P)',
        nameHindi: 'फास्फोरस',
        current: 18,
        optimal: 20,
        status: NutrientStatus.low,
      ),
      potassium: NutrientReading(
        name: 'Potassium (K)',
        nameHindi: 'पोटेशियम',
        current: 25,
        optimal: 27,
        status: NutrientStatus.low,
      ),
      fertilizers: [
        FertilizerRecommendation(
          name: 'Urea',
          nameHindi: 'यूरिया',
          amountKg: 87,
          target: 'Nitrogen Gap',
        ),
        FertilizerRecommendation(
          name: 'DAP',
          nameHindi: 'डीएपी',
          amountKg: 43,
          target: 'Phosphorus Gap',
        ),
        FertilizerRecommendation(
          name: 'MOP',
          nameHindi: 'एमओपी',
          amountKg: 33,
          target: 'Potassium Gap',
        ),
      ],
      expertTip:
          'Apply fertilizers in three splits for maximum Nitrogen absorption.\nउर्वरकों को तीन भागों में डालें ताकि नाइट्रोजन अधिकतम अवशोषित हो।',
      lastUpdated: DateTime.now(),
      sector: 'Sector 4B-East',
    );
  }
}
