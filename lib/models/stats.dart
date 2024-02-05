import 'dart:collection';

import 'package:flutter/material.dart';

enum StatsPageView { week, month, allTime }

String getPageViewString(StatsPageView pageView) {
  switch (pageView) {
    case StatsPageView.week:
      return "THIS WEEK";
    case StatsPageView.month:
      return "THIS MONTH";
    case StatsPageView.allTime:
      return "ALL TIME";
  }
}


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

  set filterList(List<StatsFilterItem> filterList) {
    _filterList = filterList;
    notifyListeners();
  }

  bool shouldUpdateStats = false;
}

class StatsFilterItem {
  final String name;
  bool included;

  StatsFilterItem({required this.name, required this.included});
}

class StatsPageViewIndex extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set index(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  int _length = 0;

  int get length => _length;

  set length(int newLength) {
    _length = newLength;
    notifyListeners();
  }
}
