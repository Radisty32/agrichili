import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TimeRangeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final List<String> ranges;

  const TimeRangeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    this.ranges = const ['Hari Ini', '7 Hari', '30 Hari', 'Kustom 📅'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(ranges.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(index),
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
}
