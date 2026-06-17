class RoutePlan {
  final DateTime date;
  final List<int> customerIds; // ordered
  final bool isAutoOptimized;

  RoutePlan({
    required this.date,
    required this.customerIds,
    this.isAutoOptimized = false,
  });
}
