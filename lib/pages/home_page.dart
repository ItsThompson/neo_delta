import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/widgets/greeting.dart';
import 'package:neo_delta/widgets/landmark_delta_button.dart';
import 'package:neo_delta/widgets/recurring_delta_grid.dart';
import 'package:neo_delta/widgets/sentence_summary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("NeoDelta.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            ],
          ),
          titleSpacing: 30,
          automaticallyImplyLeading: false,
          backgroundColor: mainTheme.colorScheme.background),
      body: Container(
        margin:
            const EdgeInsets.only(top: 15, left: 30, right: 30),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Greeting(),
            SentenceSummary(),
            LandmarkDeltaButton(),
            RecurringDeltaGrid()
          ],
        ),
      ),
    );
  }
}
