import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/sensor/sensor_node_info_card.dart';
import '../widgets/sensor/soil_moisture_gauge_card.dart';
import '../widgets/sensor/relay_control_card.dart';

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
            const SensorNodeInfoCard(),
            const SizedBox(height: 14),

            // 2. Real-time Soil Moisture Arc Gauge Card
            const SoilMoistureGaugeCard(),
            const SizedBox(height: 14),

            // 3. Relay Pompa Irigasi Card
            RelayControlCard(
              autoRelayEnabled: _autoRelayEnabled,
              onAutoRelayChanged: (val) => setState(() => _autoRelayEnabled = val),
              selectedDurationIndex: _selectedDurationIndex,
              onDurationSelected: (index) => setState(() => _selectedDurationIndex = index),
              isManualWatering: _isManualWatering,
              onToggleManual: _toggleManualIrrigation,
            ),
          ],
        ),
      ),
    );
  }
}
