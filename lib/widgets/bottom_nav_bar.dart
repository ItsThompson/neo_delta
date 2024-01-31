import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';

class NavBarItem {
  final String name;
  final String imageSrc;

  NavBarItem({required this.name, required this.imageSrc});
}

List<NavBarItem> bottomNavBarItems = [
  NavBarItem(name: "Home", imageSrc: "assets/navbar/Home.png"),
  NavBarItem(name: "Stats", imageSrc: "assets/navbar/Stats.png"),
  NavBarItem(name: "New Delta", imageSrc: "assets/navbar/NewDelta.png"),
  NavBarItem(name: "Social", imageSrc: "assets/navbar/Social.png"),
  NavBarItem(name: "Profile", imageSrc: "assets/navbar/Profile.png"),
];

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            height: 70,
            margin: const EdgeInsets.only(left:30, right: 30, bottom: 30),
            // margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: 60,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage("assets/navbar/navbarbg.png"),
                          fit: BoxFit.fill),
                      color: mainTheme.colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: mainTheme.colorScheme.surface.withOpacity(0.5),
                          offset: const Offset(5, 10),
                          blurRadius: 20,
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(bottomNavBarItems.length, (index) {
                      double boxSize = 50;
                      double edgeInset = 12.5;
                      // Middle Button
                      if (index == 2) {
                        boxSize = 100;
                        edgeInset = 0;
                      }
                      return SizedBox(
                        height: boxSize,
                        width: boxSize,
                        child: Container(
                          margin: EdgeInsets.all(edgeInset),
                          child: Image.asset(bottomNavBarItems[index].imageSrc),
                        ),
                      );
                    }),
                  ),
                )
              ],
            )));
  }
}
