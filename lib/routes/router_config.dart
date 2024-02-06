import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/pages/home_page.dart';
import 'package:neo_delta/pages/landmark_delta.dart';
import 'package:neo_delta/pages/landmark_delta_full_page.dart';
import 'package:neo_delta/pages/landmark_delta_month_selection.dart';
import 'package:neo_delta/pages/landmark_delta_year_selection.dart';
import 'package:neo_delta/pages/new_landmark_delta.dart';
import 'package:neo_delta/pages/new_recurring_delta.dart';
import 'package:neo_delta/pages/recurring_delta.dart';
import 'package:neo_delta/pages/stats_page.dart';
import 'package:neo_delta/widgets/app_bar_with_back_button.dart';
import 'package:neo_delta/widgets/navbar/bottom_nav_bar.dart';

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
            routes: [
              GoRoute(
                path: "recurring-deltas/:id",
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return RecurringDeltaPage(id: id);
                },
                // const RecurringDeltaSummary(id: state.pathParameters['id']),
              )
            ]),
        GoRoute(
          path: "/stats",
          builder: (context, state) => const StatsPage(),
        ),
      ],
    ),
    ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            extendBody: true,
            appBar: const AppBarWithBackButton(title: "LANDMARK DELTA"),
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: "/landmark-deltas",
            builder: (context, state) => const LandmarkDeltaYearSelection(),
          ),
          GoRoute(
              path: "/landmark-deltas/:year",
              builder: (context, state) {
                final year = int.parse(state.pathParameters['year']!);
                return LandmarkDeltaMonthSelection(year: year);
              }),
          GoRoute(
              path: "/landmark-deltas/:year/:month",
              builder: (context, state) {
                final year = int.parse(state.pathParameters['year']!);
                final month = int.parse(state.pathParameters['month']!);
                return LandmarkDeltaPage(year: year, month: month);
              }),
          GoRoute(
              path: "/landmark-delta-full-page/:id",
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return LandmarkDeltaFullPage(id: id);
              }),
        ]),
    GoRoute(
      path: "/new-recurring-delta",
      builder: (context, state) => const NewRecurringPage(),
    ),
    GoRoute(
      path: "/new-landmark-delta",
      builder: (context, state) => const NewLandmarkPage(),
    ),
  ],
);
