import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BottomSaveButton extends StatelessWidget {
  final VoidCallback onSave;
  final String buttonText;
  final String captionText;

  const BottomSaveButton({
    super.key,
    required this.onSave,
    this.buttonText = 'Simpan Pengaturan Ambang Batas',
    this.captionText = 'Sinkronisasi langsung ke node IoT mikrokontroler via MQTT.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: Text(
              buttonText,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
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
        Center(
          child: Text(
            captionText,
            style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
          ),
        ),
      ],
    );
  }
}
