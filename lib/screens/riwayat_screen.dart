import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/common_widgets.dart';
import '../widgets/telemetry_chart.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  int _selectedTimeRange = 1; // 0: Hari Ini, 1: 7 Hari, 2: 30 Hari, 3: Kustom
  int _selectedParam = 0; // 0: Kelembaban Tanah, 1: Suhu Udara, 2: Kelembaban Udara, 3: Radiasi Cahaya

  final List<HourlyLog> _hourlyLogs = const [
    HourlyLog(
      time: '14:00',
      metricText: '68.0% • 28.4°C',
      sourceText: 'MQTT Gateway A-1',
      badgeText: 'Normal',
      statusType: StatusType.optimal,
    ),
    HourlyLog(
      time: '13:00',
      metricText: '67.2% • 29.1°C',
      sourceText: 'MQTT Gateway A-1',
      badgeText: 'Normal',
      statusType: StatusType.optimal,
    ),
    HourlyLog(
      time: '12:00',
      metricText: '65.0% • Durasi: 2.4L Selesai',
      sourceText: 'Katup V-02 Otomatis',
      badgeText: 'Irigasi',
      statusType: StatusType.info,
    ),
    HourlyLog(
      time: '11:00',
      metricText: '58.0% • Penurunan Cepat',
      sourceText: 'Peringatan FCM & SMS',
      badgeText: 'Peringatan',
      statusType: StatusType.danger,
    ),
  ];

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
            const Text(
              'AgriChili Monitor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark,
                letterSpacing: -0.3,
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle Tag
            const Text(
              'TELEMETRI TANAMAN CABAI',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGreen,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Riwayat & Analitik Telemetri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Zone Dropdown Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.grass, size: 16, color: AppTheme.primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    'Blok A - Greenhouse 1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Time Range Tabs
            const Text(
              'RENTANG WAKTU',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            _buildTimeRangeSelector(),
            const SizedBox(height: 14),

            // Parameter Chips
            const Text(
              'PARAMETER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textMuted,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 6),
            _buildParameterSelector(),
            const SizedBox(height: 14),

            // Chart Card: Fluktuasi Kelembaban Tanah
            _buildChartCard(),
            const SizedBox(height: 14),

            // Statistik Periode 7 Hari Card
            _buildStatisticsCard(),
            const SizedBox(height: 14),

            // Log Telemetri Per Jam
            _buildHourlyLogCard(),
            const SizedBox(height: 14),

            // Unduh Laporan Telemetri
            _buildExportCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = ['Hari Ini', '7 Hari', '30 Hari', 'Kustom 📅'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(ranges.length, (index) {
          final isSelected = _selectedTimeRange == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeRange = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    ranges[index],
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textBody,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildParameterSelector() {
    final params = [
      {'name': 'Kelembaban Tanah', 'icon': Icons.water_drop},
      {'name': 'Suhu Udara', 'icon': Icons.thermostat},
      {'name': 'Kelembaban Udara', 'icon': Icons.cloud_queue},
      {'name': 'Radiasi Cahaya', 'icon': Icons.light_mode},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(params.length, (index) {
          final isSelected = _selectedParam == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              selected: isSelected,
              showCheckmark: false,
              avatar: Icon(
                params[index]['icon'] as IconData,
                size: 14,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
              label: Text(
                params[index]['name'] as String,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textDark,
                ),
              ),
              selectedColor: AppTheme.primaryGreen,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.cardBorder,
                ),
              ),
              onSelected: (val) {
                if (val) setState(() => _selectedParam = index);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChartCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fluktuasi Kelembaban\nTanah',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.statusOptimalBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Live Sync',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Rentang 7 Hari Terakhir (9 Mar - 15 Mar 2024)',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Chart Legends
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildLegendBox(AppTheme.accentGreen.withValues(alpha: 0.35), 'Target Aman (60% - 80%)'),
              _buildLegendLine(AppTheme.primaryGreen, 'Tren Tanaman'),
              _buildLegendLine(AppTheme.statusInfoText, 'Irigasi Tetes', isDashed: false),
            ],
          ),
          const SizedBox(height: 14),

          // Custom Painted Chart
          const TelemetryHistoryChart(height: 170),
          const SizedBox(height: 14),

          // Alert Detection Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.statusDangerBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.statusDangerBg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.statusDangerText,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7F1D1D),
                        height: 1.35,
                      ),
                      children: [
                        TextSpan(
                          text: 'Deteksi Kritis: ',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: 'Kelembaban di bawah 55% selama 1 jam pada 14 Mei 11:00 WIB sebelum irigasi pemulihan 2.4L aktif.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLegendLine(Color color, String label, {bool isDashed = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 2.5,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Statistik Periode 7 Hari',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Blok A',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
                  value: '69.4 %',
                  badge: const StatusBadge(text: 'Optimal', type: StatusType.optimal),
                  icon: Icons.bar_chart,
                ),
              ),
              Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: _buildStatItem(
                  label: 'TERTINGGI',
                  value: '78.1 %',
                  subtext: '10 Mei • 06:15',
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
                  value: '57.2 %',
                  subtext: '14 Mei • 11:30',
                  icon: Icons.arrow_downward,
                  iconColor: AppTheme.statusDangerText,
                ),
              ),
              Container(width: 1, height: 48, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: _buildStatItem(
                  label: 'DI LUAR BATAS',
                  value: '1j 20m',
                  subtext: 'Tren 0.8%',
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

  Widget _buildHourlyLogCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Log Telemetri Per Jam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Text(
                'Sinkron Per 1 Jam',
                style: TextStyle(
                  fontSize: 10.5,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Data sensor terverifikasi gateway IoT greenhouse',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          ..._hourlyLogs.map((log) => _buildLogRow(log)),
        ],
      ),
    );
  }

  Widget _buildLogRow(HourlyLog log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              log.time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.metricText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  log.sourceText,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            text: log.badgeText,
            type: log.statusType,
          ),
        ],
      ),
    );
  }

  Widget _buildExportCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.download, size: 16, color: AppTheme.primaryGreen),
              SizedBox(width: 6),
              Text(
                'Unduh Laporan Telemetri',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Data mentah kelembaban, suhu, dan catatan durasi irigasi siap untuk audit agronomi.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Laporan CSV berhasil diunduh!')),
                    );
                  },
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('CSV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    side: const BorderSide(color: AppTheme.primaryGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Laporan Excel (.xlsx) berhasil diekspor!')),
                    );
                  },
                  icon: const Icon(Icons.table_chart_outlined, size: 16),
                  label: const Text('Excel (.xlsx)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

