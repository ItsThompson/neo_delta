import 'dart:math';
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

class StatsData {
  final List<(DateTime, double)> progress;

  bool hasNegativeValues() {
    for (var i = 0; i < progress.length; i++) {
      if (progress[i].$2 < 0) {
        return true;
      }
    }
    return false;
  }

  (double, double) getMinMax() {
    double maximum = progress[0].$2;
    double minimum = progress[0].$2;
    for (var i = 1; i < progress.length; i++) {
      if (progress[i].$2 > maximum) {
        maximum = progress[i].$2;
      }
      if (progress[i].$2 < minimum) {
        minimum = progress[i].$2;
      }
    }

    if (hasNegativeValues()) {
      double range = max(maximum.abs(), minimum.abs());
      return (-range, range);
    }
    return (0, maximum);
  }

  factory StatsData.generateFakeData(int length, int maximum, int minimum) {
    List<(DateTime, double)> progress = [];
    Random random = Random();
    double randomNumber;
    DateTime dateTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    for (var i = 0; i < length; i++) {
      randomNumber = double.parse(
          (minimum + random.nextDouble() * (maximum - minimum))
              .toStringAsFixed(2));
      progress.add((dateTime, randomNumber));
      dateTime = dateTime.add(const Duration(days: 1));
    }
    return StatsData(progress: progress);
  }

  StatsData({required this.progress});
}
