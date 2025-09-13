class DashboardCard {
  final int id;
  final String title;
  final int value;
  final String valueType;
  final String formattedValue;
  final String prefix;
  final String icon;
  final double trend;
  final String trendDirection;
  final String tooltip;

  const DashboardCard({
    required this.id,
    required this.title,
    required this.value,
    required this.valueType,
    required this.formattedValue,
    required this.prefix,
    required this.icon,
    required this.trend,
    required this.trendDirection,
    required this.tooltip,
  });

  factory DashboardCard.fromJson(Map<String, dynamic> json) {
    return DashboardCard(
      id: json['id'] as int,
      title: json['title'] as String,
      value: json['value'] as int,
      valueType: json['valueType'] as String,
      formattedValue: json['formattedValue'] as String,
      prefix: json['prefix'] as String,
      icon: json['icon'] as String,
      trend: (json['trend'] as num).toDouble(),
      trendDirection: json['trendDirection'] as String,
      tooltip: json['tooltip'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'valueType': valueType,
      'formattedValue': formattedValue,
      'prefix': prefix,
      'icon': icon,
      'trend': trend,
      'trendDirection': trendDirection,
      'tooltip': tooltip,
    };
  }
}
