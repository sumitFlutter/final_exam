import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_exam/utils/routes/shopping_app_routes.dart';

import 'firebase_options.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      routes: shoppingAppRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
