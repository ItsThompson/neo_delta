import 'package:provider/provider.dart';

class Filter {
  final List<FilterItem> filterList;

  Filter({

}

class FilterItem {
  final String name;
  final bool included;

  FilterItem({required this.name, required this.included});
}
