import 'dart:async';
import 'dart:convert';

import 'package:eunseoeunseoeunseoeunseoeunseo/models/product_model.dart';
import 'package:eunseoeunseoeunseoeunseoeunseo/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appCtrl = AppCtrl();

class AppCtrl {
  bool validTkn = false;

  Timer? _timer;
  int unreadCount = 0;
  List<ProductModel> products = [];
  late final SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    tkn = preferences.getString(tkn_key);
    final res = await g('/users/me');
    if (res.statusCode == 200) {
      validTkn = true;
      await getNotifications();
      polling();
    }
  }

  Future<void> getNotifications() async {
    try {
      final res = await g('notifications');
      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {}
    } catch (e) {}
  }

  void polling() {
    if (_timer != null) return;
    _timer = Timer.periodic(
      Duration(seconds: 30),
      (timer) async => await getNotifications(),
    );
  }
}
