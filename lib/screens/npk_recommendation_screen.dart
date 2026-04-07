import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aahar_app/theme.dart';
import 'package:aahar_app/models/npk_result.dart';

class NpkRecommendationScreen extends StatelessWidget {
  const NpkRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = NpkResult.mock();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('NPK Report / उर्वरक सलाह'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(context, result),
              const SizedBox(height: 20),

              // Nutrient Cards
              _buildNutrientCard(context, result.nitrogen),
              const SizedBox(height: 12),
              _buildNutrientCard(context, result.phosphorus),
              const SizedBox(height: 12),
              _buildNutrientCard(context, result.potassium),
              const SizedBox(height: 24),

              // Historical NPK Trends Chart
              _buildNpkTrendsChart(context),
              const SizedBox(height: 24),

              // Fertilizer Prescription
              _buildFertilizerSection(context, result),
              const SizedBox(height: 20),

              // Expert Tip
              _buildExpertTip(context, result.expertTip),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NpkResult result) {
    return Container(
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
              const Icon(Icons.assignment, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Aahar Soil Report',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          Text(
            'आहार मिट्टी रिपोर्ट',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Last updated: Today, 10:42 AM • ${result.sector}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(BuildContext context, NutrientReading reading) {
    final statusColor = _getStatusColor(reading.status);
    final statusLabel = _getStatusLabel(reading.status);

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.eco, color: statusColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reading.name,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    Text(
                      reading.nameHindi,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Status: $statusLabel',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current: ${reading.current.toStringAsFixed(0)} ${reading.unit}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Optimal: ${reading.optimal.toStringAsFixed(0)} ${reading.unit}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.statusOptimal,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (reading.percentage / 100).clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: statusColor.withValues(alpha: 0.12),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFertilizerSection(BuildContext context, NpkResult result) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              const Icon(Icons.medication,
                  color: AppTheme.primaryContainer, size: 22),
              const SizedBox(width: 10),
              Text(
                'Fertilizer Prescription',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Text(
            'उर्वरक नुस्खा',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ...result.fertilizers
              .map((f) => _buildFertilizerRow(context, f)),
        ],
      ),
    );
  }

  Widget _buildFertilizerRow(
      BuildContext context, FertilizerRecommendation fert) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.inventory_2,
                  color: AppTheme.primaryContainer, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fert.name} / ${fert.nameHindi}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Target: ${fert.target}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${fert.amountKg.toStringAsFixed(0)} kg',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertTip(BuildContext context, String tip) {
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
            child: const Icon(Icons.lightbulb,
                color: AppTheme.secondary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expert Tip',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
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

  // ─── Historical NPK Trends (6 months) ───
  Widget _buildNpkTrendsChart(BuildContext context) {
    // Mock 6-month data (Nov → Apr)
    const nData = [210.0, 225.0, 218.0, 250.0, 235.0, 240.0];
    const pData = [14.0, 16.0, 15.0, 19.0, 17.0, 18.0];
    const kData = [20.0, 22.0, 21.0, 26.0, 24.0, 25.0];
    const months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Icon(Icons.timeline,
                  color: AppTheme.primaryContainer, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'NPK Trends / एनपीके रुझान',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Last 6 months data / पिछले 6 महीनों का डेटा',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),

          // Legend
          Row(
            children: [
              _buildLegendDot(
                  context, 'Nitrogen (N)', const Color(0xFFE53935)),
              const SizedBox(width: 16),
              _buildLegendDot(
                  context, 'Phosphorus (P)', const Color(0xFF1E88E5)),
              const SizedBox(width: 16),
              _buildLegendDot(
                  context, 'Potassium (K)', const Color(0xFFFB8C00)),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 300,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 60,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            months[idx],
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        String label;
                        switch (spot.barIndex) {
                          case 0:
                            label = 'N';
                            break;
                          case 1:
                            label = 'P';
                            break;
                          case 2:
                            label = 'K';
                            break;
                          default:
                            label = '';
                        }
                        return LineTooltipItem(
                          '$label: ${spot.y.toStringAsFixed(0)} kg/ha',
                          TextStyle(
                            color: spot.bar.color ?? Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Nitrogen line (red)
                  _buildLine(nData, const Color(0xFFE53935)),
                  // Phosphorus line (blue) — scaled ×10 for visibility
                  _buildLine(
                      pData.map((v) => v * 10).toList(), const Color(0xFF1E88E5)),
                  // Potassium line (orange) — scaled ×8 for visibility
                  _buildLine(
                      kData.map((v) => v * 8).toList(), const Color(0xFFFB8C00)),
                ],
                // Optimal zone shading (240-280 for N)
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    HorizontalRangeAnnotation(
                      y1: 240,
                      y2: 280,
                      color: AppTheme.statusOptimal.withValues(alpha: 0.07),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Annotation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: AppTheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Green zone = Optimal range  •  P & K values are scaled for readability',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLine(List<double> data, Color color) {
    return LineChartBarData(
      spots: data
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.white,
            strokeWidth: 2.5,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.06),
      ),
    );
  }

  Widget _buildLegendDot(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.onSurfaceVariant,
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Color _getStatusColor(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.low:
        return AppTheme.statusAlert;
      case NutrientStatus.optimal:
        return AppTheme.statusOptimal;
      case NutrientStatus.high:
        return AppTheme.statusWarning;
    }
  }

  String _getStatusLabel(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.low:
        return 'Low | कम';
      case NutrientStatus.optimal:
        return 'Optimal | अनुकूल';
      case NutrientStatus.high:
        return 'High | अधिक';
    }
  }
}
