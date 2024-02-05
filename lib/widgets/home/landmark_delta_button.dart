import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class LandmarkDeltaButton extends StatelessWidget {
  const LandmarkDeltaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Ink(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: mainTheme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
            onTap: () {
              context.push("/landmark-deltas");
                },
            child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: mainTheme.colorScheme.inversePrimary.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset("assets/landmark.png"),
                    ),
                    const Text("LANDMARK DELTAS")
                  ],
                ))),
      ),
    );
  }
}


