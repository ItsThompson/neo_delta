import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class NavBarItem {
  final String name;
  final String imageSrc;
  final String route;

  NavBarItem({required this.name, required this.imageSrc, required this.route});
}

List<NavBarItem> bottomNavBarItems = [
  NavBarItem(name: "Home", imageSrc: "assets/navbar/Home.png", route: "/"),
  NavBarItem(
      name: "Stats", imageSrc: "assets/navbar/Stats.png", route: "/stats"),
  NavBarItem(
      name: "New Delta", imageSrc: "assets/navbar/NewDelta.png", route: "/"),
  NavBarItem(name: "Social", imageSrc: "assets/navbar/Social.png", route: "/"),
  NavBarItem(
      name: "Profile", imageSrc: "assets/navbar/Profile.png", route: "/"),
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
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Stack(
              children: <Widget>[
                // Background
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
                // Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Individual Button
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
                          child: GestureDetector(
                            onTap: () {
                              final String currentUri = GoRouter.of(context)
                                  .routerDelegate
                                  .currentConfiguration
                                  .last
                                  .route
                                  .path
                                  .toString();
                              if (currentUri !=
                                  bottomNavBarItems[index].route) {
                                context.push(bottomNavBarItems[index].route);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(edgeInset),
                              child: Image.asset(
                                  bottomNavBarItems[index].imageSrc),
                            ),
                          ));
                    }),
                  ),
                )
              ],
            )));
  }
}
