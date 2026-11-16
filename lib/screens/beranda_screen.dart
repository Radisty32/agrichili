import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/beranda/device_status_card.dart';
import '../widgets/beranda/zone_selector_card.dart';
import '../widgets/beranda/telemetry_metric_card.dart';
import '../widgets/beranda/quick_irrigation_card.dart';
import '../widgets/beranda/block_card.dart';

class BerandaScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const BerandaScreen({super.key, this.onNavigateTab});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _isPumping = false;

  void _triggerQuickIrrigation() {
    setState(() {
      _isPumping = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.water_drop, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text('Irigasi Siram Cepat (3 Menit) Berhasil Diaktifkan!'),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isPumping = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppTheme.mintBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sensors,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'AgriChili Monitor',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: AppTheme.textDark,
                  size: 24,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ESP32 Node Status Banner
            const DeviceStatusCard(),
            const SizedBox(height: 12),

            // 2. Zona Monitoring Aktif Card
            const ZoneSelectorCard(),
            const SizedBox(height: 16),

            // 3. Section: Telemetri Real-Time Lahan
            _buildTelemetrySectionHeader(),
            const SizedBox(height: 10),

            // Telemetry Metric Card
            TelemetryMetricCard(
              title: 'KELEMBABAN TANAH',
              icon: Icons.water_drop_outlined,
              value: '68',
              unit: '%',
              target: 'Target: 60% - 80%',
              badge: 'Optimal',
              badgeType: StatusType.optimal,
              progressValue: 68,
              onTap: () => widget.onNavigateTab?.call(1), // Go to Sensor
            ),
            const SizedBox(height: 14),

            // 4. Quick Action Irrigation Card
            QuickIrrigationCard(
              isPumping: _isPumping,
              onTrigger: _triggerQuickIrrigation,
            ),
            const SizedBox(height: 20),

            // 5. Section: Pemantauan Seluruh Blok Lahan
            _buildBlockSectionHeader(),
            const SizedBox(height: 10),

            BlockCard(
              title: 'Blok A (Greenhouse 1)',
              subtitle: 'Cabai Rawit',
              moisture: '68%',
              badgeText: 'Optimal',
              badgeType: StatusType.optimal,
              indicatorColor: AppTheme.accentGreen,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
            const SizedBox(height: 8),

            BlockCard(
              title: 'Blok B (Lahan Terbuka)',
              subtitle: 'Cabai Keriting',
              moisture: '54% (Kering)',
              badgeText: 'Perlu Perhatian',
              badgeType: StatusType.warning,
              indicatorColor: AppTheme.statusWarningText,
              onTap: () => widget.onNavigateTab?.call(2), // Go to Riwayat
            ),
            const SizedBox(height: 8),

            BlockCard(
              title: 'Blok C (Pembibitan)',
              subtitle: 'Semaian HST 8',
              moisture: '76%',
              badgeText: 'Optimal',
              badgeType: StatusType.optimal,
              indicatorColor: AppTheme.accentGreen,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetrySectionHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'TELEMETRI REAL-TIME LAHAN',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 12, color: AppTheme.textMuted),
              SizedBox(width: 4),
              Text(
                '10 Detik',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlockSectionHeader() {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'PEMANTAUAN SELURUH BLOK LAHAN',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '3 Blok Aktif',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}
