import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocket_market_module_a/common.dart';
import 'package:pocket_market_module_a/models/user_model.dart';
import 'package:pocket_market_module_a/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AppController appController = AppController();

class AppController {
  Timer? _timer;
  late SharedPreferences prefs;
  late UserModel userModel;
  int currentIndex = 0;
  int unreadCount = 0;

  Future<void> getNotification() async {
    try {
      final res = await g('/notifications');
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        unreadCount = body['unreadCount'];
        updateScreen();
      }
    } catch (e, st) {}
  }

  void polling() async {
    if (_timer != null) return;
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) async => await getNotification(),
    );
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString(tokenKey);
  }
}
