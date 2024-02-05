import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';

class NavBarItem {
  final String name;
  final String imageSrc;
  final String route;

  NavBarItem({required this.name, required this.imageSrc, required this.route});
}

List<NavBarItem> bottomLeftNavBarItems = [
  NavBarItem(name: "Home", imageSrc: "assets/navbar/Home.png", route: "/"),
  NavBarItem(
      name: "Stats", imageSrc: "assets/navbar/Stats.png", route: "/stats"),
];

List<NavBarItem> bottomRightNavBarItems = [
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
    double padding = 40;
    double actionButtonSize = 100;
    return SafeArea(
        child: Container(
            height: actionButtonSize,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Stack(
              children: <Widget>[
                // Background
                Container(
                  margin: EdgeInsets.symmetric(vertical: padding / 2),
                  height: actionButtonSize - padding,
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
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Individual Button
                    children: List.generate(
                        bottomLeftNavBarItems.length +
                            bottomRightNavBarItems.length +
                            1, (index) {
                      double iconSize = 30;
                      int indexForItemList = index % 3;

                      // Middle Button
                      if (index == 2) {
                        return FloatingNewDeltaButton(
                            actionButtonSize: actionButtonSize);
                        // return SizedBox.square(dimension: iconSize);
                      }

                      List<NavBarItem> itemList = bottomLeftNavBarItems;
                      if (index > 2) {
                        itemList = bottomRightNavBarItems;
                      }

                      return IconButton(
                          onPressed: () {
                            final String currentUri = GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .last
                                .route
                                .path
                                .toString();
                            if (currentUri !=
                                itemList[indexForItemList].route) {
                              context.replace(itemList[indexForItemList].route);
                            }
                          },
                          style: IconButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          icon: Image.asset(
                            itemList[indexForItemList].imageSrc,
                            width: iconSize,
                          ));
                    }),
                  ),
                )
              ],
            )));
  }
}

class FloatingNewDeltaButton extends StatefulWidget {
  final double actionButtonSize;
  const FloatingNewDeltaButton({super.key, required this.actionButtonSize});

  @override
  State<FloatingNewDeltaButton> createState() => _FloatingNewDeltaButtonState();
}

class _FloatingNewDeltaButtonState extends State<FloatingNewDeltaButton> {
  String iconSrc = "assets/navbar/NewDelta.png";
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          newDeltaButtonBottomModal(context);
        },
        style: IconButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ),
        icon: Image.asset(
          iconSrc,
          height: widget.actionButtonSize,
          width: widget.actionButtonSize,
        ));
  }
}

Future<void> newDeltaButtonBottomModal(BuildContext context) {
  return showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        height: 215,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: mainTheme.colorScheme.inversePrimary.withOpacity(0.5),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const Text('Select Delta Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push("/new-recurring-delta");
                },
                icon: Image.asset("assets/icons/recurring.png", width: 25),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        mainTheme.colorScheme.secondary)),
                label: Text(
                  "New Recurring Delta",
                  style: TextStyle(
                      color: mainTheme.colorScheme.inversePrimary,
                      fontSize: 20),
                )),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push("/new-landmark-delta");
                },
                icon: Image.asset("assets/landmark.png", width: 25),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        mainTheme.colorScheme.secondary)),
                label: Text(
                  "New Landmark Delta",
                  style: TextStyle(
                      color: mainTheme.colorScheme.inversePrimary,
                      fontSize: 20),
                )),
          ],
        ),
      ));
    },
  );
}
