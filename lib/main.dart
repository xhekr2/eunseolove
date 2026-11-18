import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_market_module_a/controllers/app_controller.dart';
import 'package:pocket_market_module_a/screens/login_screen.dart';
import 'package:pocket_market_module_a/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([.portraitDown, .portraitUp]);

  await appController.init();

  runApp(
    MaterialApp(
      navigatorKey: navKey,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          surfaceTintColor: Colors.transparent,
        ),
      ),
    ),
  );
}
