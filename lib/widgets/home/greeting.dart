import 'package:flutter/material.dart';
import 'package:neo_delta/services/current_datetime.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  String getGreeting() {
    DateTime now = currentDateTime();
    String greeting;
    switch (now.hour) {
      case >= 5 && <= 11:
        greeting = "Good Morning, ";
      case >= 12 && <= 17:
        greeting = "Good Afternoon, ";
      case (>= 18 && <= 23) || (>= 0 && <= 4):
        greeting = "Good Evening, ";
      default:
        greeting = "Hello, ";
    }
    return greeting;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${getGreeting()}Thompson",
      style: const TextStyle(fontSize: 20),
    );
  }
}
