import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class LandmarkDeltaPage extends StatelessWidget {
  const LandmarkDeltaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Container(
                margin: const EdgeInsets.only(left: 5),
                child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ))),
            title: const Text("LANDMARK DELTA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            titleSpacing: 30,
            automaticallyImplyLeading: false,
            backgroundColor: mainTheme.colorScheme.background),
        body: const Text("landmark_delta"));
  }
}
