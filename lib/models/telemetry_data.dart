enum StatusType {
  optimal,
  warning,
  danger,
  info,
}

class BlockInfo {
  final String title;
  final String subtitle;
  final int moisture;
  final String status;
  final StatusType statusType;

  const BlockInfo({
    required this.title,
    required this.subtitle,
    required this.moisture,
    required this.status,
    required this.statusType,
  });
}

class HourlyLog {
  final String time;
  final String metricText;
  final String sourceText;
  final String badgeText;
  final StatusType statusType;

  const HourlyLog({
    required this.time,
    required this.metricText,
    required this.sourceText,
    required this.badgeText,
    required this.statusType,
  });
}

class CultivationPreset {
  final String id;
  final String title;
  final String ageRange;
  final String description;
  final String conditions;
  final double defaultSoilMin;
  final double defaultSoilMax;
  final double defaultTempMin;
  final double defaultTempMax;

  const CultivationPreset({
    required this.id,
    required this.title,
    required this.ageRange,
    required this.description,
    required this.conditions,
    required this.defaultSoilMin,
    required this.defaultSoilMax,
    required this.defaultTempMin,
    required this.defaultTempMax,
  });
}
