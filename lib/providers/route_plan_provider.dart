import 'package:flutter/material.dart';
import '../models/route_plan.dart';

class RoutePlanProvider extends ChangeNotifier {
  RoutePlan? _todayPlan;

  RoutePlan? get todayPlan => _todayPlan;

  // Hardcoded plan for now
  void loadMockPlan() {
    _todayPlan = RoutePlan(
      date: DateTime.now(),
      customerIds: [3, 1, 5, 2, 4], // ordered manually
      isAutoOptimized: false,
    );
    notifyListeners();
  }

  // Later: manager-defined plan
  void setManualPlan(List<int> orderedCustomerIds) {
    _todayPlan = RoutePlan(
      date: DateTime.now(),
      customerIds: orderedCustomerIds,
      isAutoOptimized: false,
    );
    notifyListeners();
  }

  // Later: system-optimized plan
  void setAutoOptimizedPlan(List<int> orderedCustomerIds) {
    _todayPlan = RoutePlan(
      date: DateTime.now(),
      customerIds: orderedCustomerIds,
      isAutoOptimized: true,
    );
    notifyListeners();
  }
}
