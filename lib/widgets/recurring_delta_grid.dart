import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';

class RecurringDeltaGrid extends StatelessWidget {
  const RecurringDeltaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 25,
      crossAxisSpacing: 25,
      children: List.generate(100, (index) {
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: mainTheme.colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: mainTheme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: mainTheme.colorScheme.surface.withOpacity(0.5),
                      offset: const Offset(5, 10),
                      blurRadius: 20,
                    )
                  ]),
              child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: mainTheme.colorScheme.surface,
                    // TODO: Changes color when clicked
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Delta $index"),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset("assets/landmark.png"),
                      ),
                      const Text(
                        "3 LEFT THIS WEEK",
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  ))),
        );
      }),
    ));
  }
}
