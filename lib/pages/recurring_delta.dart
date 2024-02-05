import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class RecurringDeltaPage extends StatefulWidget {
  final int id;
  const RecurringDeltaPage({super.key, required this.id});

  @override
  State<RecurringDeltaPage> createState() => _RecurringDeltaPageState();
}

class _RecurringDeltaPageState extends State<RecurringDeltaPage> {
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
            title: const Text("RECURRING DELTA",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            titleSpacing: 30,
            automaticallyImplyLeading: false,
            backgroundColor: mainTheme.colorScheme.background),
        body: Text("recurring_delta with id ${widget.id}"));
  }
}
