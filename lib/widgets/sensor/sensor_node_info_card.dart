import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class SensorNodeInfoCard extends StatelessWidget {
  final String nodeId;
  final String firmwareVersion;
  final String rssi;
  final String battery;
  final String broker;

  const SensorNodeInfoCard({
    super.key,
    this.nodeId = 'ESP32-NODE-01',
    this.firmwareVersion = 'Mikrokontroler Agrikultur ESP32 Dual-Core • v2.4.1',
    this.rssi = '-64 dBm',
    this.battery = '92% 3.9V',
    this.broker = 'Aktif',
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
              Text(
                nodeId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              const StatusBadge(
                text: 'Online',
                type: StatusType.optimal,
                showDot: true,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            firmwareVersion,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildNodeSpec(
                  icon: Icons.wifi,
                  iconColor: AppTheme.primaryGreen,
                  title: rssi,
                  subtitle: 'Sangat Kuat',
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildNodeSpec(
                  icon: Icons.battery_charging_full_rounded,
                  iconColor: AppTheme.accentGreen,
                  title: battery,
                  subtitle: 'Solar Assisted',
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildNodeSpec(
                  icon: Icons.cloud_done_outlined,
                  iconColor: AppTheme.statusInfoText,
                  title: broker,
                  subtitle: 'broker.hivemq',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNodeSpec({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
