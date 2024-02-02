import 'package:flutter/material.dart';

class StatsFilter extends ChangeNotifier{
  final List<StatsFilterItem> filterList;

  StatsFilter({required this.filterList});
}

class StatsFilterItem {
  final String name;
  final bool included;

  StatsFilterItem({required this.name, required this.included});
}
