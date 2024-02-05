import 'package:flutter/material.dart';
import 'package:neo_delta/main_theme.dart';

class NavBarBackground extends StatefulWidget {
  final double padding;
  final double height;
  const NavBarBackground({super.key, required this.padding, required this.height});

  @override
  State<NavBarBackground> createState() => _NavBarBackgroundState();
}

class _NavBarBackgroundState extends State<NavBarBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: widget.padding / 2),
      height: widget.height, //actionButtonSize - padding,
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
    );
  }
}
