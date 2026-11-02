import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/common_widgets.dart';
import '../widgets/arc_gauge.dart';
import '../widgets/multi_line_chart.dart';

class SensorDetailScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SensorDetailScreen({super.key, this.onBack});

  @override
  State<SensorDetailScreen> createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  bool _autoRelayEnabled = true;
  int _selectedDurationIndex = 1; // 0: 2 Menit, 1: 5 Menit, 2: 10 Menit
  bool _isManualWatering = false;

  void _toggleManualIrrigation() {
    setState(() {
      _isManualWatering = !_isManualWatering;
    });

    final durations = ['2 Menit', '5 Menit', '10 Menit'];
    final dur = durations[_selectedDurationIndex];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isManualWatering ? Icons.water_drop : Icons.stop_circle_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _isManualWatering
                    ? 'Irigasi Manual Dinyalakan ($dur)!'
                    : 'Irigasi Manual Dimatikan.',
              ),
            ),
          ],
        ),
        backgroundColor: _isManualWatering ? AppTheme.primaryGreen : Colors.blueGrey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Detail Lahan & Sensor',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Blok A - Greenhouse 1 Cabai Rawit Merah',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: AppTheme.textSecondary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data sensor diperbarui dari gateway.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ESP32 Node Telemetry Info Card
            _buildNodeInfoCard(),
            const SizedBox(height: 14),

            // 2. Real-time Soil Moisture Arc Gauge Card
            _buildSoilMoistureGaugeCard(),
            const SizedBox(height: 14),

            // 3. 6-Hour Telemetry Trend Multi-line Chart Card
            _buildTrendChartCard(),
            const SizedBox(height: 14),

            // 4. Relay Pompa Irigasi Card
            _buildRelayControlCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeInfoCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'ESP32-NODE-01',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              StatusBadge(
                text: 'Online',
                type: StatusType.optimal,
                showDot: true,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Mikrokontroler Agrikultur ESP32 Dual-Core • v2.4.1',
            style: TextStyle(
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
                  title: '-64 dBm',
                  subtitle: 'Sangat Kuat',
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildNodeSpec(
                  icon: Icons.battery_charging_full_rounded,
                  iconColor: AppTheme.accentGreen,
                  title: '92% 3.9V',
                  subtitle: 'Solar Assisted',
                ),
              ),
              Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildNodeSpec(
                  icon: Icons.cloud_done_outlined,
                  iconColor: AppTheme.statusInfoText,
                  title: 'Aktif',
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

  Widget _buildSoilMoistureGaugeCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kelembaban Tanah Riil',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              StatusBadge(
                text: 'Optimal Cabai',
                type: StatusType.optimal,
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Sensor Kedalaman Akar Aktif',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Arc Speedometer Gauge
          const ArcGauge(value: 68),
        ],
      ),
    );
  }

  Widget _buildTrendChartCard() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tren Telemetri 6 Jam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Row(
                children: [
                  _buildLegendDot(const Color(0xFF0284C7), 'Tanah'),
                  const SizedBox(width: 8),
                  _buildLegendDot(const Color(0xFFEF4444), 'Suhu'),
                  const SizedBox(width: 8),
                  _buildLegendDot(const Color(0xFF10B981), 'Udara'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Pembaruan berkala interval 2 menit',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Multi-line Trend Chart
          const MultiLineTrendChart(height: 130),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRelayControlCard() {
    final durations = ['2 Menit', '5 Menit', '10 Menit'];

    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.power_settings_new, size: 16, color: AppTheme.primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    'Relay Pompa Irigasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
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
                value: _autoRelayEnabled,
                onChanged: (val) => setState(() => _autoRelayEnabled = val),
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
              final isSelected = _selectedDurationIndex == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < durations.length - 1 ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: () => setState(() => _selectedDurationIndex = index),
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

          // Big Green Action Button: Nyalakan Manual Irigasi
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _toggleManualIrrigation,
              icon: Icon(
                _isManualWatering ? Icons.stop : Icons.water_drop,
                size: 18,
              ),
              label: Text(
                _isManualWatering ? 'Hentikan Manual Irigasi' : 'Nyalakan Manual Irigasi',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isManualWatering ? const Color(0xFFDC2626) : AppTheme.primaryGreen,
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
