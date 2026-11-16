import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class RelayControlCard extends StatelessWidget {
  final bool autoRelayEnabled;
  final ValueChanged<bool> onAutoRelayChanged;
  final int selectedDurationIndex;
  final ValueChanged<int> onDurationSelected;
  final bool isManualWatering;
  final VoidCallback onToggleManual;

  const RelayControlCard({
    super.key,
    required this.autoRelayEnabled,
    required this.onAutoRelayChanged,
    required this.selectedDurationIndex,
    required this.onDurationSelected,
    required this.isManualWatering,
    required this.onToggleManual,
  });

  @override
  Widget build(BuildContext context) {
    final durations = ['2 Menit', '5 Menit', '10 Menit'];

    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, size: 16, color: AppTheme.primaryGreen),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Relay Pompa Irigasi',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6),
              StatusBadge(
                text: 'Siaga',
                type: StatusType.optimal,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Line 01 - Umpil Irigasi',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Automatic Switch Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Otomatis Berbasis Sensor',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Aktif bila VWC < 60% dan suhu > 28°C',
                      style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: autoRelayEnabled,
                onChanged: onAutoRelayChanged,
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Durasi Penyiraman Options
          const Text(
            'Durasi Penyiraman:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(durations.length, (index) {
              final isSelected = selectedDurationIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < durations.length - 1 ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: () => onDurationSelected(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryGreen : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          durations[index],
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Big Action Button: Nyalakan Manual Irigasi
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onToggleManual,
              icon: Icon(
                isManualWatering ? Icons.stop : Icons.water_drop,
                size: 18,
              ),
              label: Text(
                isManualWatering ? 'Hentikan Manual Irigasi' : 'Nyalakan Manual Irigasi',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isManualWatering ? const Color(0xFFDC2626) : AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Footer Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 13, color: AppTheme.accentGreen),
                  SizedBox(width: 4),
                  Text(
                    'Dry-Run Protection Aktif',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                'Tekanan: 2.4 Bar',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
