import 'package:flutter/material.dart';
import 'package:neo_delta/widgets/recurring_delta_button.dart';

class RecurringDeltaGrid extends StatelessWidget {
  const RecurringDeltaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 25,
      crossAxisSpacing: 25,
      children: List.generate(6, (index) {
          return RecurringDeltaButton(index: index);
      }),
    ));
  }
}
