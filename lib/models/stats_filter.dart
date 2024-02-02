import 'package:flutter/material.dart';

class StatsFilter extends ChangeNotifier {
  List<StatsFilterItem> filterList = [
    StatsFilterItem(name: "ALL TASKS", included: true),
    StatsFilterItem(name: "DELTA 1", included: true),
    StatsFilterItem(name: "DELTA 2", included: true),
    StatsFilterItem(name: "DELTA 3", included: true),
    StatsFilterItem(name: "DELTA 4", included: true),
    StatsFilterItem(name: "DELTA 5", included: true),
    StatsFilterItem(name: "DELTA 6", included: true),
  ];

  void setIncluded(int index, bool val) {
    filterList[index].included = val;
    notifyListeners();
  }
}

class StatsFilterItem {
  final String name;
  bool included;

  StatsFilterItem({required this.name, required this.included});
}
