import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neo_delta/main_theme.dart';

Future<String> getRandomPhrase() async {
  Random random = Random();
  String fileString = await rootBundle.loadString("assets/data/phrases.json");

  final data = jsonDecode(fileString);
  int index = random.nextInt(data['phrases'].length);
  return data['phrases'][index];
}

String thirtyDayProgress() {
  // TODO: Thirty Day Calculation
  Random random = Random();
  // MAX: (1.01)^30 = 0.34784892
  int percentageProgress = random.nextInt(35);
  return " $percentageProgress% ";
}

TextSpan upOrDown() {
  // HACK: Modify when done with Thirty Day Calculation
  Random random = Random();
  bool isPositive = random.nextBool();
  if (isPositive) {
    return TextSpan(
        text: "up",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: mainTheme.colorScheme.primary));
  }

  return TextSpan(
      text: "down",
      style: TextStyle(
          fontWeight: FontWeight.bold, color: mainTheme.colorScheme.tertiary));
}

class SentenceSummary extends StatelessWidget {
  const SentenceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getRandomPhrase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: mainTheme.colorScheme.primary,
            ));
          }

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 25),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/navbar/navbarbg.png"),
                    fit: BoxFit.fill),
                color: mainTheme.colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: mainTheme.colorScheme.surface.withOpacity(0.5),
                    offset: const Offset(5, 10),
                    blurRadius: 20,
                  )
                ]),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(text: "You are "),
                      // UP/DOWN
                      upOrDown(),
                      // PERCENTAGE
                      TextSpan(
                          text: thirtyDayProgress(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: "compared to 30 days ago. "),
                      // Cheerful Phrase
                      TextSpan(
                          text: snapshot.data,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ])),
          );
        });
  }
}
