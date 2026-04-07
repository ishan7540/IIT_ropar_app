class Farmer {
  final String id;
  final String name;
  final String email;
  final String fieldName;
  final String location;
  final double fieldAreaAcres;

  Farmer({
    required this.id,
    required this.name,
    required this.email,
    required this.fieldName,
    required this.location,
    required this.fieldAreaAcres,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      fieldName: json['field_name'] ?? '',
      location: json['location'] ?? '',
      fieldAreaAcres: (json['field_area_acres'] ?? 0).toDouble(),
    );
  }

  // Mock farmer for development
  static Farmer mock() {
    return Farmer(
      id: 'f001',
      name: 'Suresh Kumar',
      email: 'suresh@aahar.in',
      fieldName: 'Field A - North Zone',
      location: 'Varanasi, Uttar Pradesh',
      fieldAreaAcres: 4.5,
    );
  }
}
