import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';

// TODO: Maybe JSON FILE
List<String> cheerfulPhrases = [
  "Keep it up!",
  "Fantastic job!",
  "Believe in yourself.",
  "You've got this!",
  "Way to go!",
  "Stay positive, stay fighting, stay brave, stay ambitious.",
  "Every small step counts.",
  "Progress, not perfection.",
  "Smile, you're making progress!",
  "Success is a journey, not a destination.",
  "You're unstoppable!",
  "Persistence pays off.",
  "Your effort is making a difference.",
  "The only way to do great work is to love what you do.",
  "In the middle of difficulty lies opportunity."
];


// TODO: May need to be stateful because the number needs to update when user completes recurring deltas.
class SentenceSummary extends StatelessWidget {
  const SentenceSummary({super.key});

  String thirtyDayProgress() {
    // TODO: Thirty Day Calculation
    Random random = Random();
    // MAX: (1.01)^30 = 0.34784892
    int percentageProgress = random.nextInt(35);
    return " $percentageProgress% ";
  }

  TextSpan upOrDown() {
    // HACK: Remove when done with Thirty Day Calculation
    Random random = Random();
    bool isPositive = random.nextBool();
    if (isPositive) {
      return TextSpan(
          text: "up",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: mainTheme.colorScheme.primary));
    }

    return TextSpan(
        text: "down",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: mainTheme.colorScheme.tertiary));
  }

  String getRandomPhrase() {
    Random random = Random();
    int index = random.nextInt(cheerfulPhrases.length);
    return cheerfulPhrases[index];
  }

  @override
  Widget build(BuildContext context) {
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
                    text: getRandomPhrase(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                // TextSpan(
                //     text: "green",
                //     style: TextStyle(color: mainTheme.colorScheme.primary)),
              ])),
    );
  }
}
