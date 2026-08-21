// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/route/data/route_repository.dart';
import 'package:grad_project/features/route/models/route_hive.dart';
import 'package:grad_project/features/route/models/route_stop_hive.dart';

class RouteProvider extends ChangeNotifier {
  final RouteRepository _repo;
  final CustomerProvider _customerProvider;

  RouteProvider(this._repo, this._customerProvider);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RouteHive? todayRoute;

  Future<void> loadTodayRoute() async {
    _isLoading = true;
    notifyListeners();

    try {
      todayRoute = await _repo.syncTodayRoute();
    } catch (e) {
      print("Failed to load route: $e");
      // todayRoute = _repo.getTodayRoute();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<RouteStopHive> get stops => todayRoute?.stops ?? [];

  /// ⭐ Only customers in today's route
  List<CustomerHive> get routeCustomers {
    final all = _customerProvider.customers;

    return stops
        .map((s) => all.where((c) => c.id == s.customerId).toList())
        .where((list) => list.isNotEmpty)
        .map((list) => list.first)
        .toList();
  }

  RouteHive? get route => _repo.getTodayRoute();
}
