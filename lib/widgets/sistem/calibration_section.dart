import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../common_widgets.dart';

class CalibrationSection extends StatelessWidget {
  final RangeValues soilMoistureRange;
  final ValueChanged<RangeValues> onSoilMoistureChanged;
  final VoidCallback onResetDefault;

  const CalibrationSection({
    super.key,
    required this.soilMoistureRange,
    required this.onSoilMoistureChanged,
    required this.onResetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kalibrasi Rentang Metrik',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              InkWell(
                onTap: onResetDefault,
                child: const Text(
                  'Reset Default',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.statusInfoText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Sesuaikan batas bawah & atas toleransi sensor',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Slider 1: Kelembaban Tanah
          _buildRangeSliderItem(
            context: context,
            title: 'Kelembaban Tanah',
            icon: Icons.water_drop,
            targetText: 'Target: 60% - 80%',
            unit: '%',
            values: soilMoistureRange,
            min: 0,
            max: 100,
            onChanged: onSoilMoistureChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSliderItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String targetText,
    required String unit,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primaryGreen),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const Spacer(),
            Text(
              targetText,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildBoundaryBox('Batas Bawah', '${values.start.round()} $unit')),
            const SizedBox(width: 8),
            Expanded(child: _buildBoundaryBox('Batas Atas', '${values.end.round()} $unit')),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryGreen,
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: AppTheme.primaryGreen,
            overlayColor: AppTheme.accentGreen.withValues(alpha: 0.15),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBoundaryBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }
}
