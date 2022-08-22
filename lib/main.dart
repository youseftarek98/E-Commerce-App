import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await initAppModule();
  runApp(MyApp());
}

/// flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs