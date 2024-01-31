import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/widgets/bottom_nav_bar.dart';
import 'package:neo_delta/widgets/greeting.dart';
import 'package:neo_delta/widgets/recurring_delta_grid.dart';
import 'package:neo_delta/widgets/sentence_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        margin: const EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Greeting(),
            const SentenceSummary(),
            GestureDetector(
                onTap: () => {
                      // TODO: Route to Landmark Page
                    },
                child: Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: mainTheme.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                mainTheme.colorScheme.surface.withOpacity(0.5),
                            offset: const Offset(5, 10),
                            blurRadius: 20,
                          )
                        ]),
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: mainTheme.colorScheme.inversePrimary
                              .withOpacity(0.5),
                          // TODO: Changes color when clicked
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
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
                        )))),
            const RecurringDeltaGrid()
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
