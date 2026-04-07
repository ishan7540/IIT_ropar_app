import 'package:flutter/material.dart';
import 'package:aahar_app/theme.dart';
import 'package:aahar_app/models/alert.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<FarmAlert>? _alerts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final alerts = await FarmAlert.generateSmartAlerts();
      if (mounted) {
        setState(() {
          _alerts = alerts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications / सूचनाएं'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryContainer,
          onRefresh: _loadAlerts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Farm Alerts',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'खेत की सूचनाएं • Weather & Nutrients',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Refresh button
                    GestureDetector(
                      onTap: _loadAlerts,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.primaryContainer.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _isLoading
                              ? Icons.hourglass_top
                              : Icons.refresh,
                          color: AppTheme.primaryContainer,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Loading state
                if (_isLoading)
                  SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppTheme.primaryContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Analyzing weather & soil data...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'मौसम और मिट्टी डेटा का विश्लेषण...',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                // Error state
                else if (_error != null)
                  _buildErrorState(context)
                // Alerts loaded
                else if (_alerts != null) ...[
                  // Summary banner
                  _buildSummaryBanner(context),
                  const SizedBox(height: 16),

                  // Alert cards
                  ..._alerts!.map((alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildAlertCard(context, alert),
                      )),
                  const SizedBox(height: 8),

                  // Sustainable tip
                  _buildSustainableTip(context),

                  const SizedBox(height: 12),

                  // Data source footer
                  _buildDataSourceFooter(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context) {
    final criticalCount =
        _alerts!.where((a) => a.severity == AlertSeverity.critical).length;
    final warningCount =
        _alerts!.where((a) => a.severity == AlertSeverity.warning).length;

    final hasCritical = criticalCount > 0;
    final bannerColor = hasCritical ? AppTheme.error : AppTheme.secondary;
    final bannerBg = hasCritical
        ? AppTheme.error.withValues(alpha: 0.08)
        : AppTheme.secondaryContainer.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(24),
        border: hasCritical
            ? Border.all(
                color: AppTheme.error.withValues(alpha: 0.15), width: 1)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bannerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              hasCritical ? Icons.warning_amber : Icons.check_circle,
              color: bannerColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasCritical
                      ? '$criticalCount Critical Alert${criticalCount > 1 ? 's' : ''}'
                      : 'Farm Status: Good',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: bannerColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasCritical
                      ? '$warningCount warning${warningCount != 1 ? 's' : ''} • Action needed today'
                      : 'All parameters within safe range',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bannerColor.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, FarmAlert alert) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: alert.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alert.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(alert.icon, color: alert.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: alert.color,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.titleHindi,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: alert.color.withValues(alpha: 0.8),
                                height: 1.4,
                              ),
                    ),
                  ],
                ),
              ),
              // Severity badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: alert.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _severityLabel(alert.severity),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: alert.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              alert.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              _formatTime(alert.timestamp),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: alert.color.withValues(alpha: 0.5),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainableTip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: AppTheme.secondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sustainable Tip / टिकाऊ खेती सुझाव',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Using bio-mulching during high temperatures reduces soil '
                  'moisture evaporation by up to 40%. Consider neem-coated urea '
                  'for slower nitrogen release.\n'
                  'उच्च तापमान में जैव-मल्चिंग से 40% तक नमी बचाई जा सकती है।',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSourceFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              size: 14, color: AppTheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Weather data: OpenWeatherMap (Patiala) • NPK: Last soil test',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 9,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off,
                color: AppTheme.onSurfaceVariant, size: 40),
            const SizedBox(height: 12),
            Text(
              'Could not generate alerts',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'सूचनाएं लोड नहीं हो सकीं',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _loadAlerts,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Retry / पुनः प्रयास करें',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _severityLabel(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.info:
        return 'INFO';
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}
