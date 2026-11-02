import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';
import '../widgets/common_widgets.dart';

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
  String _alertFrequency = 'Segera (Real-time) - Rekomendasi';

  final List<CultivationPreset> _presets = const [
    CultivationPreset(
      id: 'vegetatif',
      title: 'Fase Vegetatif',
      ageRange: '1 - 30 HST',
      description: 'Pembentukan daun & batang awal',
      conditions: 'Tanah 60-75%, Suhu 24-28°C',
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
      conditions: 'Tanah 65-80%, Suhu 25-30°C',
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
      conditions: 'Tanah 55-70%, Suhu 26-32°C',
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
            // 1. Balitbangtan Standard Physiological Banner
            _buildStandardBanner(),
            const SizedBox(height: 14),

            // 2. Preset Fase Budidaya Card
            _buildPresetSection(),
            const SizedBox(height: 14),

            // 3. Kalibrasi Rentang Metrik Card
            _buildCalibrationSection(),
            const SizedBox(height: 14),

            // 4. Otomatisasi Pompa Irigasi Card
            _buildAutomationSection(),
            const SizedBox(height: 14),

            // 5. Notifikasi Peringatan Card
            _buildNotificationSection(),
            const SizedBox(height: 18),

            // 6. Bottom Big Save Button
            _buildBottomSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardBanner() {
    return AgriCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.mintBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Standar Fisiologis Cabai Balitbangtan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ambang batas diadaptasi otomatis sesuai panduan agrikultur.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const StatusBadge(
            text: 'Aktif',
            type: StatusType.optimal,
          ),
        ],
      ),
    );
  }

  Widget _buildPresetSection() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Preset Fase Budidaya',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.mintBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Rekomendasi AI',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Pilih tahapan umur tanaman untuk memuat nilai rekomendasi',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_presets.length, (index) {
            final preset = _presets[index];
            final isSelected = _selectedPresetIndex == index;
            return GestureDetector(
              onTap: () => _onSelectPreset(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.mintBackground.withValues(alpha: 0.5) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.textMuted,
                            width: 2,
                          ),
                          color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Center(
                                child: Icon(Icons.circle, size: 8, color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                preset.title,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• ${preset.ageRange}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            preset.description,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      preset.conditions,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreen,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalibrationSection() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kalibrasi Rentang Metrik',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              InkWell(
                onTap: _resetToDefault,
                child: const Text(
                  'Reset Default',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.statusInfoText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Sesuaikan batas bawah & atas toleransi sensor',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Slider 1: Kelembaban Tanah
          _buildRangeSliderItem(
            title: 'Kelembaban Tanah',
            icon: Icons.water_drop,
            targetText: 'Target: 60% - 80%',
            unit: '%',
            values: _soilMoistureRange,
            min: 0,
            max: 100,
            onChanged: (values) => setState(() => _soilMoistureRange = values),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSliderItem({
    required String title,
    required IconData icon,
    required String targetText,
    required String unit,
    required RangeValues values,
    required double min,
    required double max,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primaryGreen),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const Spacer(),
            Text(
              targetText,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildBoundaryBox('Batas Bawah', '${values.start.round()} $unit')),
            const SizedBox(width: 8),
            Expanded(child: _buildBoundaryBox('Batas Atas', '${values.end.round()} $unit')),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryGreen,
            inactiveTrackColor: const Color(0xFFE2E8F0),
            thumbColor: AppTheme.primaryGreen,
            overlayColor: AppTheme.accentGreen.withValues(alpha: 0.15),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildBoundaryBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationSection() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Otomatisasi Pompa Irigasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Logika kontrol katup solenoid berdasarkan nilai sensor',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Switch
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Irigasi otomatis jika kelembaban di bawah batas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Solenoid drip aktif otomatis saat tanah butuh air',
                      style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _autoIrrigationEnabled,
                onChanged: (val) => setState(() => _autoIrrigationEnabled = val),
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const Divider(height: 18, color: Color(0xFFF1F5F9)),

          // Stepper 1: Durasi Siram
          _buildStepperRow(
            label: 'Durasi Siram',
            sublabel: 'Waktu per siklus aktif',
            value: '$_wateringDurationMinutes mnt',
            onDecrement: () {
              if (_wateringDurationMinutes > 1) {
                setState(() => _wateringDurationMinutes--);
              }
            },
            onIncrement: () {
              setState(() => _wateringDurationMinutes++);
            },
          ),
          const SizedBox(height: 10),

          // Stepper 2: Jeda Cooldown
          _buildStepperRow(
            label: 'Jeda Cooldown',
            sublabel: 'Waktu tunggu peresapan',
            value: '$_cooldownDurationMinutes mnt',
            onDecrement: () {
              if (_cooldownDurationMinutes > 5) {
                setState(() => _cooldownDurationMinutes -= 5);
              }
            },
            onIncrement: () {
              setState(() => _cooldownDurationMinutes += 5);
            },
          ),
          const SizedBox(height: 12),

          // Fail-safe note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 14, color: AppTheme.textSecondary),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Fail-safe: Cut-off darurat jika offline >10 mnt',
                    style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                  ),
                ),
                StatusBadge(text: 'Aktif', type: StatusType.optimal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow({
    required String label,
    required String sublabel,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              sublabel,
              style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onDecrement,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.remove, size: 14, color: AppTheme.textDark),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textDark),
                ),
              ),
              InkWell(
                onTap: onIncrement,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.add, size: 14, color: AppTheme.textDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifikasi Peringatan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pengiriman sinyal peringatan ke ponsel via Firebase Cloud',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Switch
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Kirim notifikasi saat nilai melewati ambang batas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Peringatan prioritas tinggi untuk kondisi darurat',
                      style: TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
                activeColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Dropdown Frekuensi
          const Text(
            'Frekuensi Peringatan',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _alertFrequency,
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppTheme.textDark),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: AppTheme.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text(
              'Simpan Pengaturan Ambang Batas',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Sinkronisasi langsung ke node IoT mikrokontroler via MQTT.',
            style: TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
          ),
        ),
      ],
    );
  }
}

