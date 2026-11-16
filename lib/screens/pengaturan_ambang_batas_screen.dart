import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/sistem/preset_section.dart';
import '../widgets/sistem/calibration_section.dart';
import '../widgets/sistem/automation_section.dart';
import '../widgets/sistem/notification_section.dart';
import '../widgets/sistem/bottom_save_button.dart';

class PengaturanAmbangBatasScreen extends StatefulWidget {
  const PengaturanAmbangBatasScreen({super.key});

  @override
  State<PengaturanAmbangBatasScreen> createState() => _PengaturanAmbangBatasScreenState();
}

class _PengaturanAmbangBatasScreenState extends State<PengaturanAmbangBatasScreen> {
  int _selectedPresetIndex = 0;

  // Sliders values
  RangeValues _soilMoistureRange = const RangeValues(60, 80);

  // Automation toggles & counters
  bool _autoIrrigationEnabled = true;
  int _wateringDurationMinutes = 5;
  int _cooldownDurationMinutes = 30;

  // Notification toggles
  bool _notificationsEnabled = true;
  final String _alertFrequency = 'Segera (Real-time) - Rekomendasi';

  final List<CultivationPreset> _presets = const [
    CultivationPreset(
      id: 'vegetatif',
      title: 'Fase Vegetatif',
      ageRange: '1 - 30 HST',
      description: 'Pembentukan daun & batang awal',
      conditions: 'Tanah: 60-75%',
      defaultSoilMin: 60,
      defaultSoilMax: 75,
      defaultTempMin: 24,
      defaultTempMax: 28,
    ),
    CultivationPreset(
      id: 'generatif',
      title: 'Fase Generatif / Berbunga',
      ageRange: '> 31 HST',
      description: 'Pembungaan aktif & pembentukan buah',
      conditions: 'Tanah: 65-80%',
      defaultSoilMin: 65,
      defaultSoilMax: 80,
      defaultTempMin: 25,
      defaultTempMax: 30,
    ),
    CultivationPreset(
      id: 'panen',
      title: 'Pematangan Buah & Panen',
      ageRange: '> 80 HST',
      description: 'Pematangan warna cabai & reduksi lembab',
      conditions: 'Tanah: 55-70%',
      defaultSoilMin: 55,
      defaultSoilMax: 70,
      defaultTempMin: 26,
      defaultTempMax: 32,
    ),
  ];

  void _onSelectPreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      final preset = _presets[index];
      _soilMoistureRange = RangeValues(preset.defaultSoilMin, preset.defaultSoilMax);
    });
  }

  void _resetToDefault() {
    setState(() {
      _soilMoistureRange = const RangeValues(60, 80);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kalibrasi rentang telah dikembalikan ke standar default.'),
        backgroundColor: AppTheme.primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text('Pengaturan ambang batas berhasil disinkronkan via MQTT!'),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
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
              'Pengaturan Ambang Batas',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.check, size: 15),
              label: const Text(
                'Simpan',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Preset Fase Budidaya Card
            PresetSection(
              presets: _presets,
              selectedIndex: _selectedPresetIndex,
              onSelect: _onSelectPreset,
            ),
            const SizedBox(height: 14),

            // 2. Kalibrasi Rentang Metrik Card
            CalibrationSection(
              soilMoistureRange: _soilMoistureRange,
              onSoilMoistureChanged: (values) => setState(() => _soilMoistureRange = values),
              onResetDefault: _resetToDefault,
            ),
            const SizedBox(height: 14),

            // 3. Otomatisasi Pompa Irigasi Card
            AutomationSection(
              autoIrrigationEnabled: _autoIrrigationEnabled,
              onAutoIrrigationChanged: (val) => setState(() => _autoIrrigationEnabled = val),
              wateringDurationMinutes: _wateringDurationMinutes,
              onDecrementDuration: () {
                if (_wateringDurationMinutes > 1) {
                  setState(() => _wateringDurationMinutes--);
                }
              },
              onIncrementDuration: () {
                setState(() => _wateringDurationMinutes++);
              },
              cooldownDurationMinutes: _cooldownDurationMinutes,
              onDecrementCooldown: () {
                if (_cooldownDurationMinutes > 5) {
                  setState(() => _cooldownDurationMinutes -= 5);
                }
              },
              onIncrementCooldown: () {
                setState(() => _cooldownDurationMinutes += 5);
              },
            ),
            const SizedBox(height: 14),

            // 4. Notifikasi Peringatan Card
            NotificationSection(
              notificationsEnabled: _notificationsEnabled,
              onNotificationsChanged: (val) => setState(() => _notificationsEnabled = val),
              alertFrequency: _alertFrequency,
            ),
            const SizedBox(height: 18),

            // 5. Bottom Big Save Button
            BottomSaveButton(onSave: _saveSettings),
          ],
        ),
      ),
    );
  }
}
