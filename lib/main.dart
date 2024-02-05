import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neo_delta/main_theme.dart';
import 'package:neo_delta/models/stats.dart';
import 'package:neo_delta/routes/router_config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StatsFilter(),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsPageViewIndex(),
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
