import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ParameterSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ParameterSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
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
          final isSelected = selectedIndex == index;
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
                if (val) onSelect(index);
              },
            ),
          );
        }),
      ),
    );
  }
}
