import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String blockSubtitle;
  final String averageValue;
  final String peakValue;
  final String peakTime;
  final String lowestValue;
  final String lowestTime;
  final String outOfBoundsDuration;
  final String outOfBoundsTrend;

  const StatisticsCard({
    super.key,
    this.title = 'Statistik Periode 7 Hari',
    this.blockSubtitle = 'Blok A',
    this.averageValue = '69.4 %',
    this.peakValue = '78.1 %',
    this.peakTime = '10 Mei • 06:15',
    this.lowestValue = '57.2 %',
    this.lowestTime = '14 Mei • 11:30',
    this.outOfBoundsDuration = '1j 20m',
    this.outOfBoundsTrend = 'Tren 0.8%',
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  blockSubtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'RATA-RATA',
                  value: averageValue,
                  badge: const StatusBadge(text: 'Optimal', type: StatusType.optimal),
                  icon: Icons.bar_chart,
                ),
              ),
              Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: _buildStatItem(
                  label: 'TERTINGGI',
                  value: peakValue,
                  subtext: peakTime,
                  icon: Icons.arrow_upward,
                  iconColor: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'TERENDAH',
                  value: lowestValue,
                  subtext: lowestTime,
                  icon: Icons.arrow_downward,
                  iconColor: AppTheme.statusDangerText,
                ),
              ),
              Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: _buildStatItem(
                  label: 'DI LUAR BATAS',
                  value: outOfBoundsDuration,
                  subtext: outOfBoundsTrend,
                  icon: Icons.timer_outlined,
                  iconColor: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    String? subtext,
    Widget? badge,
    required IconData icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Icon(icon, size: 14, color: iconColor ?? AppTheme.textMuted),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                badge,
              ],
            ],
          ),
          if (subtext != null) ...[
            const SizedBox(height: 2),
            Text(
              subtext,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
