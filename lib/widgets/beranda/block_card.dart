import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class BlockCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String moisture;
  final String badgeText;
  final StatusType badgeType;
  final Color indicatorColor;
  final VoidCallback? onTap;

  const BlockCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.moisture,
    required this.badgeText,
    required this.badgeType,
    required this.indicatorColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 38,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelembaban Tanah: $moisture',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: badgeType == StatusType.warning
                        ? AppTheme.statusWarningText
                        : AppTheme.textBody,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            text: badgeText,
            type: badgeType,
            showDot: true,
          ),
        ],
      ),
    );
  }
}
