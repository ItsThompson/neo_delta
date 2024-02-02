import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/pages/home_page.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/bottom_nav_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          extendBody: true,
          body: child,
          bottomNavigationBar: const BottomNavBar(),
        );
      },
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: "/stats",
          builder: (context, state) => const StatsPage(),
        ),
      ],
    )
  ],
);
