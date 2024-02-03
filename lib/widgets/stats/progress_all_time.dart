import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/pages/stats_page.dart';

class AllTimeProgress extends StatefulWidget {
  final StatsData statsData;

  const AllTimeProgress({super.key, required this.statsData});

  @override
  State<AllTimeProgress> createState() => _AllTimeProgressState();
}

class _AllTimeProgressState extends State<AllTimeProgress> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30, right: 30, left: 30, bottom: 10),
        child: const Text(
          "YOUR PROGRESS EVERY MONTH",
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
          height: 250,
          width: double.infinity,
          child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: List.generate(
                    widget.statsData.progress.length,
                    (index) =>
                        AllTimeRow(data: widget.statsData.progress[index])),
              )))
    ]);
  }
}

class AllTimeRow extends StatefulWidget {
  final (DateTime, double) data;
  const AllTimeRow({super.key, required this.data});

  @override
  State<AllTimeRow> createState() => _AllTimeRowState();
}

class _AllTimeRowState extends State<AllTimeRow> {
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.data.$1;
    final double progress = widget.data.$2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${date.year}-${date.month.toString().padLeft(2, '0')}",
          style: const TextStyle(fontSize: 16),
        ),
        Container(
            height: 25,
            width: 200,
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: progress == 0
                  ? mainTheme.colorScheme.inversePrimary.withOpacity(0.5)
                  : (progress < 0
                      ? mainTheme.colorScheme.tertiary.withOpacity(0.5)
                      : mainTheme.colorScheme.primary.withOpacity(0.5)),
            ),
            child: Center(
              child: Text(
                "$progress",
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }
}
