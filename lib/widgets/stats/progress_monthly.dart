import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';

class MonthlyProgress extends StatefulWidget {
  final StatsData statsData;
  const MonthlyProgress({super.key, required this.statsData});

  @override
  State<MonthlyProgress> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MonthlyProgress> {
  double spacingBetweenEachBox = 15;
  double boxSize = 40;
  DateTime now = DateTime.now();

  List<String> daysOfTheWeek = [
    'MON',
    'TUE',
    'WED',
    'THUR',
    'FRI',
    'SAT',
    'SUN'
  ];

  int get startingIndex {
    DateTime firstDayOfMonth = DateTime.utc(now.year, now.month, 1);

    return firstDayOfMonth.weekday - 1;
  }

  int get itemsInThisMonth {
    DateTime lastDayOfMonth = DateTime.utc(now.year, now.month + 1, 1)
        .subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

  int get numberOfFullRows {
    int remainingStatPoints = itemsInThisMonth;
    int initOffset = daysOfTheWeek.length - startingIndex;
    remainingStatPoints -= initOffset;
    return remainingStatPoints ~/ daysOfTheWeek.length;
  }

  int get lastRowMax {
    int remainingStatPoints = itemsInThisMonth;
    int initOffset = daysOfTheWeek.length - startingIndex;
    remainingStatPoints -= initOffset;
    return remainingStatPoints % daysOfTheWeek.length;
  }

  @override
  Widget build(BuildContext context) {
    double tableCellSize = boxSize + spacingBetweenEachBox;

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(tableCellSize),
          children: generateTableRows(),
        ));
  }

  SizedBox generateBox(int index) {
    double tableCellSize = boxSize + spacingBetweenEachBox;

    SizedBox internalBoxGenerator(Color color, Widget? child) {
      return SizedBox.square(
          dimension: tableCellSize,
          child: Container(
              margin: EdgeInsets.all(spacingBetweenEachBox / 2),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: child));
    }

    Color color = mainTheme.colorScheme.inverseSurface.withOpacity(0.5);

    if (index >= widget.statsData.progress.length) {
      return internalBoxGenerator(color, null);
    }

    String text;
    double roundedValue =
        double.parse(widget.statsData.progress[index].$2.toStringAsFixed(1));

    if (roundedValue == 0.0) {
      text = "0.0";
    } else if (roundedValue > 0) {
      text = "+$roundedValue";
    } else {
      text = "$roundedValue";
    }

    if (roundedValue < 0) {
      color = mainTheme.colorScheme.tertiary.withOpacity(0.5);
    } else if (roundedValue > 0) {
      color = mainTheme.colorScheme.primary.withOpacity(0.5);
    } else {
      color = mainTheme.colorScheme.secondary.withOpacity(0.8);
    }

    Widget child = Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );

    return internalBoxGenerator(color, child);
  }

  List<TableRow> generateTableRows() {
    int statDataIndex = 0;
    List<TableRow> tableRows = [];

    TableRow headings = TableRow(
      children: List.generate(
          daysOfTheWeek.length,
          (index) => TableCell(
                  child: Text(
                daysOfTheWeek[index],
                textAlign: TextAlign.center,
              ))),
    );

    tableRows.add(headings);

    TableRow initial = TableRow(
        children: List.generate(daysOfTheWeek.length, (index) {
      if (index < startingIndex) {
        return const SizedBox.shrink();
      }
      SizedBox out = generateBox(statDataIndex);
      statDataIndex += 1;
      return out;
    }));

    tableRows.add(initial);

    for (var i = 0; i < numberOfFullRows; i++) {
      TableRow middleRow = TableRow(
          children: List.generate(daysOfTheWeek.length, (index) {
        SizedBox out = generateBox(statDataIndex);
        statDataIndex += 1;
        return out;
      }));

      tableRows.add(middleRow);
    }

    if (lastRowMax != 0) {
      TableRow tail = TableRow(
          children: List.generate(daysOfTheWeek.length, (index) {
        if (index >= lastRowMax) {
          return const SizedBox.shrink();
        }
        SizedBox out = generateBox(statDataIndex);
        statDataIndex += 1;
        return out;
      }));

      tableRows.add(tail);
    }

    return tableRows;
  }
}
