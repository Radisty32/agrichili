import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/riwayat/time_range_selector.dart';
import '../widgets/riwayat/parameter_selector.dart';
import '../widgets/riwayat/fluctuation_chart_card.dart';
import '../widgets/riwayat/statistics_card.dart';
import '../widgets/riwayat/hourly_log_card.dart';
import '../widgets/riwayat/export_report_card.dart';

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
            TimeRangeSelector(
              selectedIndex: _selectedTimeRange,
              onSelect: (index) => setState(() => _selectedTimeRange = index),
            ),
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
            ParameterSelector(
              selectedIndex: _selectedParam,
              onSelect: (index) => setState(() => _selectedParam = index),
            ),
            const SizedBox(height: 14),

            // Chart Card: Fluktuasi Kelembaban Tanah
            const FluctuationChartCard(),
            const SizedBox(height: 14),

            // Statistik Periode 7 Hari Card
            const StatisticsCard(),
            const SizedBox(height: 14),

            // Log Telemetri Per Jam
            HourlyLogCard(logs: _hourlyLogs),
            const SizedBox(height: 14),

            // Unduh Laporan Telemetri
            const ExportReportCard(),
          ],
        ),
      ),
    );
  }
}
