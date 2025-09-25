class DashboardCard {
  final int id;
  final String code;
  final String title;
  final int value;
  final String valueType;
  final String formattedValue;
  final String icon;
  final double? trend;
  final String? trendDirection;
  final String? prefix;
  final String? tooltip;

  const DashboardCard({
    required this.id,
    required this.code,
    required this.title,
    required this.value,
    required this.valueType,
    required this.formattedValue,
    required this.icon,
    this.trend,
    this.trendDirection,
    this.prefix,
    this.tooltip,
  });

  factory DashboardCard.fromJson(Map<String, dynamic> json) {
    return DashboardCard(
      id: json['id'] as int,
      code: json['code'] as String? ?? '',
      title: json['title'] as String,
      value: json['value'] as int,
      valueType: json['valueType'] as String,
      formattedValue: json['formattedValue'] as String,
      icon: json['icon'] as String,
      trend: json['trend'] == null ? null : (json['trend'] as num).toDouble(),
      trendDirection: json['trendDirection'] as String?,
      prefix: json['prefix'] as String?,
      tooltip: json['tooltip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'value': value,
      'valueType': valueType,
      'formattedValue': formattedValue,
      'icon': icon,
      if (trend != null) 'trend': trend,
      if (trendDirection != null) 'trendDirection': trendDirection,
      if (prefix != null) 'prefix': prefix,
      if (tooltip != null) 'tooltip': tooltip,
    };
  }
}
