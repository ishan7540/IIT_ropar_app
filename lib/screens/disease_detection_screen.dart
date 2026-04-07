import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aahar_app/theme.dart';
import 'dart:io';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? _selectedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _result = null;
      });
    }
  }

  void _analyzeImage() {
    if (_selectedImage == null) return;
    setState(() => _isAnalyzing = true);
    // TODO: POST image to disease detection API endpoint
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _result = {
            'disease': 'Leaf Blight / पत्ती झुलसा',
            'confidence': 94.5,
            'severity': 'Moderate / मध्यम',
            'solution':
                '1. Remove affected leaves immediately\n   प्रभावित पत्तियों को तुरंत हटाएं\n\n'
                    '2. Apply Mancozeb 75% WP (2g/L water)\n   मैंकोजेब 75% WP (2g/L पानी) का छिड़काव करें\n\n'
                    '3. Ensure proper spacing between plants\n   पौधों के बीच उचित दूरी सुनिश्चित करें\n\n'
                    '4. Avoid overhead irrigation\n   ऊपरी सिंचाई से बचें',
          };
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Disease Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Text(
              'Crop Disease Detection / फसल रोग पहचान',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Upload a photo of the affected crop leaf\nप्रभावित फसल की पत्ती की फोटो अपलोड करें',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),

            // Image Preview / Upload Area
            GestureDetector(
              onTap: () => _showPickerSheet(context),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: AppTheme.primaryContainer,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to capture or upload',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.primaryContainer,
                                ),
                          ),
                          Text(
                            'फोटो लेने या अपलोड करने के लिए टैप करें',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            if (_selectedImage != null && _result == null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showPickerSheet(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: AppTheme.ambientShadow,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        icon: _isAnalyzing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(_isAnalyzing
                            ? 'Analyzing...'
                            : 'Analyze / विश्लेषण करें'),
                      ),
                    ),
                  ),
                ],
              ),

            // Results
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(context),
              const SizedBox(height: 16),
              _buildSolutionCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.errorContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child:
                    const Icon(Icons.bug_report, color: AppTheme.error, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disease Detected / रोग पाया गया',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.onErrorContainer,
                          ),
                    ),
                    Text(
                      _result!['disease'],
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.error,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetricChip(
                context,
                'Confidence',
                '${_result!['confidence']}%',
                AppTheme.error,
              ),
              const SizedBox(width: 10),
              _buildMetricChip(
                context,
                'Severity',
                _result!['severity'],
                AppTheme.statusWarning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(
      BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services,
                  color: AppTheme.primaryContainer, size: 22),
              const SizedBox(width: 10),
              Text(
                'Treatment / उपचार',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _result!['solution'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Image Source / छवि स्रोत चुनें',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerOption(
                      context,
                      Icons.camera_alt,
                      'Camera\nकैमरा',
                      () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPickerOption(
                      context,
                      Icons.photo_library,
                      'Gallery\nगैलरी',
                      () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryContainer, size: 36),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
