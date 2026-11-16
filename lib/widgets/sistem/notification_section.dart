import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../common_widgets.dart';

class NotificationSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final String alertFrequency;
  final VoidCallback? onFrequencyTap;

  const NotificationSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.alertFrequency,
    this.onFrequencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifikasi Peringatan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pengiriman sinyal peringatan ke ponsel via Firebase Cloud',
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
                      'Kirim notifikasi saat nilai melewati ambang batas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Peringatan prioritas tinggi untuk kondisi darurat',
                      style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: notificationsEnabled,
                onChanged: onNotificationsChanged,
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Dropdown Frekuensi
          const Text(
            'Frekuensi Peringatan',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: onFrequencyTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alertFrequency,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.textDark),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.textMuted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
