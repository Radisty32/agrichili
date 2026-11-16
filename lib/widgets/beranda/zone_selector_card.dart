import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../common_widgets.dart';

class ZoneSelectorCard extends StatelessWidget {
  final String zoneLabel;
  final String zoneTitle;
  final VoidCallback? onTap;

  const ZoneSelectorCard({
    super.key,
    this.zoneLabel = 'ZONA MONITORING AKTIF',
    this.zoneTitle = 'Lahan Cabai Blok A - Greenhouse 1',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            zoneLabel,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  zoneTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.textSecondary,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
