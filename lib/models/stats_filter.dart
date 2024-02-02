import 'dart:collection';

import 'package:flutter/material.dart';

class StatsFilter extends ChangeNotifier {
  List<StatsFilterItem> _filterList = [
    StatsFilterItem(name: "ALL TASKS", included: false),
    StatsFilterItem(name: "DELTA 1", included: true),
    StatsFilterItem(name: "DELTA 2", included: false),
    StatsFilterItem(name: "DELTA 3", included: false),
    StatsFilterItem(name: "DELTA 4", included: true),
    StatsFilterItem(name: "DELTA 5", included: false),
    StatsFilterItem(name: "DELTA 6", included: true),
  ];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<StatsFilterItem> get filterList =>
      UnmodifiableListView(_filterList);

  void setFilterList(List<StatsFilterItem> filterList) {
    _filterList = filterList;
    notifyListeners();
  }
}

class StatsFilterItem {
  final String name;
  bool included;

  StatsFilterItem({required this.name, required this.included});
}
