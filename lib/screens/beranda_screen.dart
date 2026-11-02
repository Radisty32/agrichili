import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/common_widgets.dart';

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
              decoration: BoxDecoration(
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
            _buildDeviceStatusCard(),
            const SizedBox(height: 12),

            // 2. Zona Monitoring Aktif Card
            _buildZoneSelectorCard(),
            const SizedBox(height: 16),

            // 3. Section: Telemetri Real-Time Lahan
            Row(
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
            ),
            const SizedBox(height: 10),

            // Telemetry Metric Card
            _buildTelemetryMetricCard(
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

            // 5. Quick Action Irrigation Card
            _buildQuickIrrigationCard(),
            const SizedBox(height: 20),

            // 6. Section: Pemantauan Seluruh Blok Lahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PEMANTAUAN SELURUH BLOK LAHAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Total 3 Blok Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            _buildBlockCard(
              title: 'Blok A (Greenhouse 1)',
              subtitle: 'Cabai Rawit',
              moisture: '68%',
              badgeText: 'Optimal',
              badgeType: StatusType.optimal,
              indicatorColor: AppTheme.accentGreen,
              onTap: () => widget.onNavigateTab?.call(1),
            ),
            const SizedBox(height: 8),

            _buildBlockCard(
              title: 'Blok B (Lahan Terbuka)',
              subtitle: 'Cabai Keriting',
              moisture: '54% (Kering)',
              badgeText: 'Perlu Perhatian',
              badgeType: StatusType.warning,
              indicatorColor: AppTheme.statusWarningText,
              onTap: () => widget.onNavigateTab?.call(2), // Go to Riwayat
            ),
            const SizedBox(height: 8),

            _buildBlockCard(
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

  Widget _buildDeviceStatusCard() {
    return AgriCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'ESP32-Chili-A1',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppTheme.statusOptimalBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.statusOptimalText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 12, color: AppTheme.textMuted),
                  SizedBox(width: 3),
                  Text(
                    '12 dtk lalu',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.wifi, size: 15, color: AppTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '-64 dBm',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                        ),
                        Text(
                          'Sangat Kuat',
                          style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.battery_charging_full_rounded, size: 16, color: AppTheme.accentGreen),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '92% 3.9V',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                        ),
                        Text(
                          'Stabil',
                          style: TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
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

  Widget _buildZoneSelectorCard() {
    return AgriCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ZONA MONITORING AKTIF',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Lahan Cabai Blok A - Greenhouse 1',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Icon(
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

  Widget _buildTelemetryMetricCard({
    required String title,
    required IconData icon,
    required String value,
    required String unit,
    required String target,
    required String badge,
    required StatusType badgeType,
    required double progressValue,
    VoidCallback? onTap,
  }) {
    return AgriCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, size: 18, color: AppTheme.primaryGreen),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                target,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
              StatusBadge(
                text: badge,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TargetProgressBar(
            value: progressValue,
            targetMin: 60,
            targetMax: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickIrrigationCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.water_drop, size: 17, color: AppTheme.primaryGreen),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pompa Irigasi Tetes',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.mintBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'AUTO SENSOR ON',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Status: Siaga | Debit Aliran: 0.0 L/mnt',
            style: TextStyle(
              fontSize: 11.5,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: _isPumping ? null : _triggerQuickIrrigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              icon: _isPumping
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.water_drop, size: 18),
              label: Text(
                _isPumping ? 'Sedang Menyiram (3 Menit)...' : 'Siram Cepat 3 Menit',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockCard({
    required String title,
    required String subtitle,
    required String moisture,
    required String badgeText,
    required StatusType badgeType,
    required Color indicatorColor,
    VoidCallback? onTap,
  }) {
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
                    color: badgeType == StatusType.warning ? AppTheme.statusWarningText : AppTheme.textBody,
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
