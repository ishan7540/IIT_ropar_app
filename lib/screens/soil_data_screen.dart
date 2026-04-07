import 'package:flutter/material.dart';
import 'package:aahar_app/theme.dart';

class SoilDataScreen extends StatefulWidget {
  const SoilDataScreen({super.key});

  @override
  State<SoilDataScreen> createState() => _SoilDataScreenState();
}

class _SoilDataScreenState extends State<SoilDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phController = TextEditingController();
  final _ecController = TextEditingController();
  final _nitrogenController = TextEditingController();
  final _phosphorusController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _fieldAreaController = TextEditingController();
  String _selectedCrop = 'Rice';
  bool _isSubmitting = false;

  final List<String> _crops = [
    'Rice',
    'Wheat',
    'Maize',
    'Sugarcane',
    'Cotton',
    'Soybean',
    'Mustard',
    'Groundnut',
    'Barley',
    'Millet',
  ];

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      // TODO: POST to Flask API /prediction endpoint
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Soil data submitted successfully! / मिट्टी का डेटा सफलतापूर्वक जमा किया गया!'),
              backgroundColor: AppTheme.primaryContainer,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _phController.dispose();
    _ecController.dispose();
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _fieldAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Soil Data / मिट्टी का डेटा'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.ambientShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.science,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Aahar: Soil Intelligence',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'आहार: मिट्टी की जानकारी',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Data for better yields.\nबेहतर पैदावार के लिए सटीक डेटा।',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  height: 1.5,
                                ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // NPK Values Section
                _buildSectionHeader(context, 'NPK VALUES / एनपीके मान',
                    Icons.grass),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _nitrogenController,
                  label: 'Nitrogen (N) / नाइट्रोजन',
                  hint: 'kg/ha',
                  icon: Icons.eco,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _phosphorusController,
                  label: 'Phosphorus (P) / फास्फोरस',
                  hint: 'kg/ha',
                  icon: Icons.eco,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _potassiumController,
                  label: 'Potassium (K) / पोटेशियम',
                  hint: 'kg/ha',
                  icon: Icons.eco,
                ),
                const SizedBox(height: 24),

                // Soil Properties
                _buildSectionHeader(context,
                    'SOIL PROPERTIES / मिट्टी के गुण', Icons.landscape),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _phController,
                  label: 'Soil pH / मिट्टी पीएच',
                  hint: '0 - 14',
                  icon: Icons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _ecController,
                  label: 'Soil EC / विद्युत चालकता',
                  hint: 'dS/m',
                  icon: Icons.electric_bolt,
                ),
                const SizedBox(height: 24),

                // Environmental
                _buildSectionHeader(context,
                    'ENVIRONMENT / पर्यावरण', Icons.thermostat),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _temperatureController,
                  label: 'Temperature / तापमान',
                  hint: '°C',
                  icon: Icons.thermostat,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _humidityController,
                  label: 'Humidity / आर्द्रता',
                  hint: '%',
                  icon: Icons.water_drop,
                ),
                const SizedBox(height: 24),

                // Field Info
                _buildSectionHeader(
                    context, 'FIELD INFO / खेत की जानकारी', Icons.map),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _fieldAreaController,
                  label: 'Field Area / खेत का क्षेत्रफल',
                  hint: 'acres',
                  icon: Icons.square_foot,
                ),
                const SizedBox(height: 12),

                // Crop Type Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCrop,
                    decoration: const InputDecoration(
                      labelText: 'Crop Type / फसल का प्रकार',
                      prefixIcon: Icon(Icons.agriculture),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                    items: _crops
                        .map((crop) => DropdownMenuItem(
                              value: crop,
                              child: Text(crop),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCrop = value!);
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.ambientShadow,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Icon(Icons.upload),
                    label: Text(
                      _isSubmitting
                          ? 'Submitting...'
                          : 'Submit Soil Data / मिट्टी डेटा जमा करें',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryContainer),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.primaryContainer,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required / आवश्यक';
        }
        return null;
      },
    );
  }
}
