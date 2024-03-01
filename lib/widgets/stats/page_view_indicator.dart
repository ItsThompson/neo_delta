import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:provider/provider.dart';

class PageViewIndicator extends StatefulWidget {
  final PageController pageController;
  const PageViewIndicator({super.key, required this.pageController});

  @override
  State<PageViewIndicator> createState() => _PageViewIndicatorState();
}

class _PageViewIndicatorState extends State<PageViewIndicator> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StatsPageViewIndex>(
        builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                value.length,
                (index) => Indicator(
                    pageController: widget.pageController,
                    currentPageIndex: value.index,
                    indicatorIndex: index))));
  }
}

class Indicator extends StatefulWidget {
  final PageController pageController;
  final int currentPageIndex;
  final int indicatorIndex;
  const Indicator(
      {super.key,
      required this.pageController,
      required this.currentPageIndex,
      required this.indicatorIndex});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.currentPageIndex == widget.indicatorIndex;
    return GestureDetector(
        onTap: () {
          widget.pageController.animateToPage(
            widget.indicatorIndex,
            duration: Duration(milliseconds: (widget.currentPageIndex - widget.indicatorIndex).abs() * 150),
            curve: Curves.easeOut,
          );
        },
        child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 25),
            padding:
                const EdgeInsets.only(bottom: 1, left: 5, right: 5, top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: Colors.white),
              color: isSelected
                  ? mainTheme.colorScheme.inverseSurface
                  : Colors.transparent,
            )));
  }
}
