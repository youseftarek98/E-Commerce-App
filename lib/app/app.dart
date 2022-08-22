import 'package:flutter/material.dart';

import '../presentations/resources/routes.dart';
import '../presentations/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  /// default constructor
  // const MyApp({Key? key}) : super(key: key);

  /// named constructor
  MyApp._internal();

  static final MyApp _instance = MyApp._internal();

  /// singleton or single instance

  factory MyApp() => _instance;

  /// factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
