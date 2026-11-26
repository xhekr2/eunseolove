import 'package:eunseoeunseoeunseoeunseoeunseo/controllers/app_ctrl.dart';
import 'package:eunseoeunseoeunseoeunseoeunseo/screens/base_screen.dart';
import 'package:eunseoeunseoeunseoeunseoeunseo/screens/login_screen.dart';
import 'package:eunseoeunseoeunseoeunseoeunseo/store.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);

  await appCtrl.init();

  runApp(
    ValueListenableBuilder(
      valueListenable: updateCount,
      builder: (context, value, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: appCtrl.validTkn ? BaseScreen() : LoginScreen(),
        navigatorKey: naviKey,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFEFEFE)),
      ),
    ),
  );
}
