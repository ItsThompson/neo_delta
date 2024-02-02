import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats_filter.dart';
import 'package:neo_delta/routes/router_config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StatsFilter(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: mainTheme,
    );
  }
}
