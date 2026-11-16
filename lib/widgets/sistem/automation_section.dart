import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class AutomationSection extends StatelessWidget {
  final bool autoIrrigationEnabled;
  final ValueChanged<bool> onAutoIrrigationChanged;
  final int wateringDurationMinutes;
  final VoidCallback onDecrementDuration;
  final VoidCallback onIncrementDuration;
  final int cooldownDurationMinutes;
  final VoidCallback onDecrementCooldown;
  final VoidCallback onIncrementCooldown;

  const AutomationSection({
    super.key,
    required this.autoIrrigationEnabled,
    required this.onAutoIrrigationChanged,
    required this.wateringDurationMinutes,
    required this.onDecrementDuration,
    required this.onIncrementDuration,
    required this.cooldownDurationMinutes,
    required this.onDecrementCooldown,
    required this.onIncrementCooldown,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Otomatisasi Pompa Irigasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Logika kontrol katup solenoid berdasarkan nilai sensor',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Switch
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Irigasi otomatis jika kelembaban di bawah batas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Solenoid drip aktif otomatis saat tanah butuh air',
                      style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: autoIrrigationEnabled,
                onChanged: onAutoIrrigationChanged,
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),

          // Stepper 1: Durasi Siram
          _buildStepperRow(
            label: 'Durasi Siram',
            sublabel: 'Waktu per siklus aktif',
            value: '$wateringDurationMinutes mnt',
            onDecrement: onDecrementDuration,
            onIncrement: onIncrementDuration,
          ),
          const SizedBox(height: 10),

          // Stepper 2: Jeda Cooldown
          _buildStepperRow(
            label: 'Jeda Cooldown',
            sublabel: 'Waktu tunggu peresapan',
            value: '$cooldownDurationMinutes mnt',
            onDecrement: onDecrementCooldown,
            onIncrement: onIncrementCooldown,
          ),
          const SizedBox(height: 12),

          // Fail-safe note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 14, color: AppTheme.textSecondary),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Fail-safe: Cut-off darurat jika offline >10 mnt',
                    style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                  ),
                ),
                StatusBadge(text: 'Aktif', type: StatusType.optimal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow({
    required String label,
    required String sublabel,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                sublabel,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onDecrement,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.remove, size: 14, color: AppTheme.textDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                ),
              ),
              InkWell(
                onTap: onIncrement,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.add, size: 14, color: AppTheme.textDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
