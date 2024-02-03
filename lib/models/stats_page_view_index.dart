import 'package:flutter/material.dart';

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
